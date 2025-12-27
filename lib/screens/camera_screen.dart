import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/camera_service.dart';
import '../services/battery_service.dart';
import '../services/tts_service.dart';
import '../services/sos_service.dart';
import '../services/mlkit_text_service.dart';
import '../services/mlkit_walking_detector.dart';
import '../services/walking_mode_service.dart';

import 'setting_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService camera = CameraService();
  final MlKitTextService textService = MlKitTextService();
  final MlKitWalkingDetector walkingDetector =
      MlKitWalkingDetector();

  WalkingModeService? walking;

  bool ready = false;
  bool busy = false;

  int tapCount = 0;
  DateTime? lastTap;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      await camera.init();
      if (mounted) setState(() => ready = true);
      await TtsService.speakHindi("कैमरा चालू हो गया है");
    } catch (_) {
      await TtsService.speakHindi("कैमरा शुरू नहीं हो पाया");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (walking != null) return;

    final size = MediaQuery.of(context).size;
    walking = WalkingModeService(
      camera: camera,
      detector: walkingDetector,
      screenWidth: size.width,
      screenHeight: size.height,
    );
  }

  void onTap() {
    final now = DateTime.now();

    if (lastTap == null ||
        now.difference(lastTap!) >
            const Duration(milliseconds: 700)) {
      tapCount = 1;
    } else {
      tapCount++;
    }

    lastTap = now;

    Future.delayed(const Duration(milliseconds: 700), () async {
      if (!mounted || busy) return;

      if (tapCount == 1) {
        await BatteryService.speakBatteryThenTime();
      } else if (tapCount == 2) {
        await _doOcr();
      } else if (tapCount >= 3) {
        await _toggleWalking();
      }

      tapCount = 0;
      lastTap = null;
    });
  }

  Future<void> _doOcr() async {
    busy = true;
    await TtsService.speakHindi("पढ़ना शुरू कर रहा हूँ");
    try {
      final XFile photo = await camera.takePhoto();
      await textService.readTextFromImage(File(photo.path));
    } catch (_) {
      await TtsService.speakHindi("पढ़ने में समस्या है");
    }
    busy = false;
  }

  Future<void> _toggleWalking() async {
    busy = true;
    if (walking == null) {
      busy = false;
      return;
    }
    walking!.toggle();
    await TtsService.speakHindi(
      walking!.enabled ? "वॉकिंग मोड चालू" : "वॉकिंग मोड बंद",
    );
    busy = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Eye"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: SosService.trigger,
        child: CameraPreview(camera.controller),
      ),
    );
  }

  @override
  void dispose() {
    walking?.dispose();
    camera.dispose();
    textService.dispose();
    walkingDetector.dispose();
    super.dispose();
  }
}
