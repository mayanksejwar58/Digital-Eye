import 'package:camera/camera.dart';

class CameraService {
  late CameraController controller;

  Future<void> init() async {
    final cams = await availableCameras();
    controller = CameraController(
      cams.first,
      ResolutionPreset.medium,
    );
    await controller.initialize();
  }

  Future<XFile> takePhoto() async {
    return await controller.takePicture();
  }

  void dispose() {
    controller.dispose();
  }
}
