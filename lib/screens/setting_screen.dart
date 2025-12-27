import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import 'login_screen.dart';
import 'emergency_setup_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          ListTile(
            title: const Text("Emergency Number"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmergencySetupScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              await TtsService.speakHindi("लॉगआउट किया जा रहा है");
              await AuthService.logout();
              await StorageService.clearEmail();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (r) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
