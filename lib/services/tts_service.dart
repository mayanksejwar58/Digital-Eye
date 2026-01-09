import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static bool _firstTime = true;

  static Future<void> speakHindi(String text) async {
    await _tts.setLanguage("hi-IN");
    await _tts.setSpeechRate(0.45);

    if (_firstTime) {
      await _tts.speak(" ");
      await Future.delayed(const Duration(milliseconds: 500));
      _firstTime = false;
    }

    await _tts.speak(text);
  }
}
