import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const String apiKey = 'sk_w73niim4_FC1u1NXdtVNj05nc4edHSeSx';
  final text = "Namaskar. This is a voice test.";

  print("1. Generating Sarvam TTS audio...");
  try {
    final response = await http.post(
      Uri.parse('https://api.sarvam.ai/text-to-speech'),
      headers: {
        'Content-Type': 'application/json',
        'api-subscription-key': apiKey,
      },
      body: jsonEncode({
        "inputs": [text],
        "target_language_code": "hi-IN",
        "speaker": "ritu",
        "pace": 1.05,
        "enable_preprocessing": true,
        "model": "bulbul:v3"
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bytes = base64Decode(data['audios'][0]);
      await File('test_audio_output.wav').writeAsBytes(bytes);
      print("Wrote test_audio_output.wav");
    } else {
      print("TTS Gen failed: ${response.body}");
    }
  } catch (e) {
    print(e);
  }
}
