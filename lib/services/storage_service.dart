import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveEmail(String email) async {
    final p = await SharedPreferences.getInstance();
    await p.setString("login_email", email);
  }

  static Future<String?> getEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString("login_email");
  }

  static Future<void> clearEmail() async {
    final p = await SharedPreferences.getInstance();
    await p.remove("login_email");
  }

  static Future<void> saveEmergency(String email, String number) async {
    final p = await SharedPreferences.getInstance();
    await p.setString("emergency_$email", number);
  }

  static Future<String?> getEmergency(String email) async {
    final p = await SharedPreferences.getInstance();
    return p.getString("emergency_$email");
  }
}
