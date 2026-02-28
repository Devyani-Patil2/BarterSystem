import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const String apiKey = 'sk_w73niim4_FC1u1NXdtVNj05nc4edHSeSx';
  final filePath = 'test_audio_output.wav';

  print("1. Testing Sarvam STT API with test_audio_output.wav...");
  try {
    final file = File(filePath);
    if (!await file.exists()) {
      print(
          "Audio file does not exist. Please ensure test_audio_output.wav is present.");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.sarvam.ai/speech-to-text-translate'),
    );
    request.headers['api-subscription-key'] = apiKey;
    request.fields['model'] = 'saaras:v2.5';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("SUCCESS: Transcript received.");
      print(data);
    } else {
      print("ERROR: ${response.body}");
    }
  } catch (e) {
    print("FATAL ERROR: $e");
  }
}
