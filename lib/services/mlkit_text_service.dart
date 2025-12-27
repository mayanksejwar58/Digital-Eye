import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'tts_service.dart';

class MlKitTextService {
  late final TextRecognizer _textRecognizer;

  MlKitTextService() {
    _textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  Future<void> readTextFromImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.trim().isEmpty) {
        await TtsService.speakHindi("कोई टेक्स्ट नहीं मिला");
      } else {
        await TtsService.speakHindi(recognizedText.text);
      }
    } catch (e) {
      await TtsService.speakHindi("टेक्स्ट पढ़ने में समस्या है");
    }
  }

  Future<String?> extractRawText(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.trim().isEmpty) return null;
      return recognizedText.text;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
