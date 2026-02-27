import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static const String _apiKey =
      'sk_w73niim4_FC1u1NXdtVNj05nc4edHSeSx'; // Provided by user
  static const String _endpoint = 'https://api.sarvam.ai/translate';

  // Cache: "text_targetLangCode" -> "translatedText"
  final Map<String, String> _memoryCache = {};
  SharedPreferences? _prefs;

  // Singleton pattern
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  /// Initialize local storage cache
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Concurrency Limiter
  int _activeRequests = 0;
  final int _maxConcurrent = 5;
  final List<Function> _queue = [];

  Future<T> _enqueue<T>(Future<T> Function() task) {
    if (_activeRequests < _maxConcurrent) {
      _activeRequests++;
      return task().whenComplete(_onTaskComplete);
    }
    final completer = Completer<T>();
    _queue.add(() {
      _activeRequests++;
      task()
          .then(completer.complete)
          .catchError(completer.completeError)
          .whenComplete(_onTaskComplete);
    });
    return completer.future;
  }

  void _onTaskComplete() {
    _activeRequests--;
    if (_queue.isNotEmpty) {
      final nextTask = _queue.removeAt(0);
      nextTask();
    }
  }

  /// Translate text into the target language code (e.g., 'hi-IN', 'mr-IN', 'en-IN')
  Future<String> translate(String text, String targetLangCode) async {
    // 1. If English is requested or text is empty, return as is (assuming source is English)
    if (text.trim().isEmpty || targetLangCode == 'en-IN') return text;

    final cacheKey = '${text}_$targetLangCode';

    // 2. Check memory cache first
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey]!;
    }

    // 3. Check disk cache (SharedPreferences)
    if (_prefs != null) {
      final diskCached = _prefs!.getString(cacheKey);
      if (diskCached != null) {
        _memoryCache[cacheKey] = diskCached;
        return diskCached;
      }
    }

    // 4. Call Sarvam AI API via Concurrency Queue
    return _enqueue(() async {
      int retries = 0;
      while (retries < 3) {
        try {
          final response = await http.post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'api-subscription-key': _apiKey,
            },
            body: jsonEncode({
              'input': text,
              'source_language_code': 'en-IN',
              'target_language_code': targetLangCode,
              'speaker_gender': 'Male',
              'mode': 'formal',
              'model': 'sarvam-translate:v1',
              'enable_preprocessing': true
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final translatedText = data['translated_text'] as String?;

            if (translatedText != null && translatedText.isNotEmpty) {
              // Save to caches
              _memoryCache[cacheKey] = translatedText;
              if (_prefs != null) {
                await _prefs!.setString(cacheKey, translatedText);
              }
              return translatedText;
            }
            break; // Valid response but no text, stop retrying
          } else if (response.statusCode == 429) {
            // Rate limit: wait and retry
            await Future.delayed(Duration(milliseconds: 600 * (retries + 1)));
            retries++;
            continue;
          } else {
            print(
                'Sarvam API Error: ${response.statusCode} - ${response.body}');
            break; // Stop retrying on other errors
          }
        } catch (e) {
          print('Translation Network Error: $e');
          await Future.delayed(Duration(milliseconds: 600 * (retries + 1)));
          retries++;
        }
      }

      // Fallback: Return original text if all retries fail
      return text;
    });
  }
}
