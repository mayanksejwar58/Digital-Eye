import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'storage_service.dart';
import 'tts_service.dart';

class SosService {
  static Future<void> trigger() async {
    final email = await StorageService.getEmail();
    if (email == null) return;

    final number = await StorageService.getEmergency(email);
    if (number == null) {
      await TtsService.speakHindi("आपातकालीन नंबर सेव नहीं है");
      return;
    }

    await Permission.phone.request();
    await launchUrl(Uri.parse("tel:$number"));
  }
}
