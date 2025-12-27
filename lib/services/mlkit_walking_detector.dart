import 'dart:io';
import 'dart:ui';

import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class DetectedObjectInfo {
  final Rect boundingBox;
  DetectedObjectInfo(this.boundingBox);
}

class MlKitWalkingDetector {
  final ObjectDetector _detector = ObjectDetector(
    options: ObjectDetectorOptions(
      classifyObjects: false,
      multipleObjects: false,
      mode: DetectionMode.single,
    ),
  );

  Future<List<DetectedObjectInfo>> detectObjectsWithBox(File img) async {
    final res =
        await _detector.processImage(InputImage.fromFile(img));

    return res
        .map((o) => DetectedObjectInfo(o.boundingBox))
        .toList();
  }

  void dispose() => _detector.close();
}
