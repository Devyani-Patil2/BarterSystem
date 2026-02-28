import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';

class VoiceService extends ChangeNotifier {
  // Singleton instance
  VoiceService._privateConstructor() {
    _initSTT();
    _initTTS();
  }
  static final VoiceService instance = VoiceService._privateConstructor();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;

  static const String _sarvamApiKey = 'sk_w73niim4_FC1u1NXdtVNj05nc4edHSeSx';

  bool _isListening = false;
  bool _isSpeechAvailable = false;
  String _recognizedText = '';

  bool get isListening => _isListening;
  bool get isSpeechAvailable => _isSpeechAvailable;
  String get recognizedText => _recognizedText;

  // --- INITIALIZATION ---

  Future<void> _initSTT() async {
    try {
      _isSpeechAvailable = await _audioRecorder.hasPermission();
    } catch (e) {
      debugPrint('Error initializing AudioRecorder: $e');
      _isSpeechAvailable = false;
    }
    notifyListeners();
  }

  Future<void> _initTTS() async {
    // AudioPlayer initializes automatically when used
    _audioPlayer.onPlayerComplete.listen((event) {
      debugPrint("Sarvam TTS Complete");
    });
  }

  // --- SPEECH TO TEXT (MIC) ---

  // Custom callback for when Sarvam returns the mapped text after we stop recording
  Function(String)? _activeCallback;

  Future<void> startListening({
    required Function(String) onResult,
    required String localeId, // e.g., 'mr-IN', 'hi-IN', 'en-IN'
  }) async {
    if (!_isSpeechAvailable) {
      debugPrint('Speech recording permission not available');
      return;
    }

    _recognizedText = '';
    _activeCallback = onResult;
    _isListening = true;
    notifyListeners();

    try {
      // Create a temporary file path
      final dir = await getTemporaryDirectory();
      _recordingPath = '${dir.path}/sarvam_stt_input.m4a';

      // Start recording
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // good balance of size vs quality
        ),
        path: _recordingPath!,
      );
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      try {
        await _audioRecorder.stop();
        _isListening = false;
        notifyListeners();

        if (_recordingPath != null && _activeCallback != null) {
          // Fire API call
          await _processSarvamSTT(_recordingPath!, _activeCallback!);
        }
      } catch (e) {
        debugPrint('Error stopping audio recording: $e');
        _isListening = false;
        notifyListeners();
      }
    }
  }

  Future<void> _processSarvamSTT(
      String filePath, Function(String) onResult) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      debugPrint("Sending audio to Sarvam STT...");

      // We send it as multipart form data
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.sarvam.ai/speech-to-text-translate'),
      );
      request.headers['api-subscription-key'] = _sarvamApiKey;
      request.fields['prompt'] = ''; // optional
      request.fields['model'] = 'saaras:v2.5';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _recognizedText = data['transcript'] ??
            ''; // Sarvam returns translated transcript in English by default!
        debugPrint("Sarvam STT Result: $_recognizedText");

        onResult(_recognizedText);
        notifyListeners();
      } else {
        debugPrint(
            'Sarvam STT Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error during Sarvam STT: $e');
    }
  }

  // --- TEXT TO SPEECH (SPEAKER) ---

  Future<void> speak(String text, {required String localeId}) async {
    if (text.isEmpty) return;

    try {
      // 1. Map typical locate to Sarvam required speaker format
      String targetLanguage = 'hi-IN'; // Default to Hindi
      if (localeId.startsWith('mr')) {
        targetLanguage = 'mr-IN';
      }

      // 2. Call Sarvam AI API
      debugPrint("Calling Sarvam AI TTS for: $text");
      final response = await http.post(
        Uri.parse('https://api.sarvam.ai/text-to-speech'),
        headers: {
          'Content-Type': 'application/json',
          'api-subscription-key': _sarvamApiKey,
        },
        body: jsonEncode({
          "inputs": [text],
          "target_language_code": targetLanguage,
          "speaker": "ritu",
          "pace": 1.05,
          "enable_preprocessing": true,
          "model": "bulbul:v3"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final base64Audio = data['audios'][0];

        // 3. Decode base64 to File
        final bytes = base64Decode(base64Audio);
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/sarvam_tts.wav');
        await file.writeAsBytes(bytes);

        // 4. Play the audio file
        await _audioPlayer.stop(); // Stop any currently playing audio
        await _audioPlayer.play(DeviceFileSource(file.path));
        debugPrint("Playing Sarvam AI Audio");
      } else {
        debugPrint(
            'Sarvam TTS Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error Sarvam TTS Speak: $e');
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error TTS Stop: $e');
    }
  }
}
