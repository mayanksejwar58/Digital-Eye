import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';
import 'tts_service.dart';

class BatteryService {
  static final Battery _battery = Battery();

  static Future<void> speakBatteryThenTime() async {
    try {
      final int batteryLevel = await _battery.batteryLevel;
      await TtsService.speakHindi(
        "बैटरी $batteryLevel प्रतिशत है",
      );

      await Future.delayed(const Duration(seconds: 1));


      final now = DateTime.now();
      final time = DateFormat('hh:mm a').format(now);
      await TtsService.speakHindi(
        "समय $time है",
      );
    } catch (_) {
    }
  }
}
