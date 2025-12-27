import 'dart:async';
import 'dart:io';

import 'camera_service.dart';
import 'mlkit_walking_detector.dart';
import 'tts_service.dart';

class WalkingModeService {
  final CameraService camera;
  final MlKitWalkingDetector detector;
  final double screenWidth;
  final double screenHeight;

  bool enabled = false;
  bool _busy = false;
  Timer? _timer;

  String? _lastSpoken;
  DateTime _lastSpeakTime = DateTime.now();

  WalkingModeService({
    required this.camera,
    required this.detector,
    required this.screenWidth,
    required this.screenHeight,
  });

  void toggle() {
    enabled = !enabled;

    if (enabled) {
      _start();
    } else {
      _stop();
    }
  }

  void _start() {
    _timer ??= Timer.periodic(
      const Duration(milliseconds: 1800),
      (_) async {
        if (!enabled || _busy) return;
        _busy = true;

        try {
          final photo = await camera.takePhoto();
          final file = File(photo.path);

          final objects = await detector.detectObjectsWithBox(file);

          if (objects.isEmpty) {
            _busy = false;
            return;
          }

          final box = objects.first.boundingBox;

          final cx = box.center.dx;
          final widthRatio = box.width / screenWidth;

          String message;

          if (cx > screenWidth * 0.35 && cx < screenWidth * 0.65) {
            if (widthRatio > 0.45) {
              message = "सामने बहुत पास बाधा है";
            } else {
              message = "सामने बाधा है";
            }
          }
          else if (cx <= screenWidth * 0.35) {
            message = "बाईं ओर बाधा है";
          }
          else {
            message = "दाईं ओर बाधा है";
          }

          final now = DateTime.now();
          if (_lastSpoken == message &&
              now.difference(_lastSpeakTime).inSeconds < 3) {
            _busy = false;
            return;
          }

          _lastSpoken = message;
          _lastSpeakTime = now;

          await TtsService.speakHindi(message);
        } catch (_) {
        }

        _busy = false;
      },
    );
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    _lastSpoken = null;
  }

  void dispose() {
    _stop();
  }
}
