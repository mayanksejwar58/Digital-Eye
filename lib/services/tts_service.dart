import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speakHindi(String text) async {
    await _tts.setLanguage("hi-IN");
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }
}
