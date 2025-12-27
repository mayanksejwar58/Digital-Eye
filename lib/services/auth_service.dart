import 'package:google_sign_in/google_sign_in.dart';
import 'storage_service.dart';

class AuthService {
  static final GoogleSignIn _google = GoogleSignIn();

  static Future<String?> login() async {
    final user = await _google.signIn();
    if (user == null) return null;
    await StorageService.saveEmail(user.email);
    return user.email;
  }

  static Future<void> logout() async {
    await _google.signOut();
    await StorageService.clearEmail();
  }
}
