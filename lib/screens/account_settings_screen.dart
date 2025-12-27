import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import 'login_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState
    extends State<AccountSettingsScreen> {

  String? email;
  final TextEditingController emergency =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    email = await StorageService.getEmail();
    if (email != null) {
      final n = await StorageService.getEmergency(email!);
      if (n != null) emergency.text = n;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account & Emergency")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Google Account"),
            const SizedBox(height: 6),
            Text(email ?? "कोई अकाउंट नहीं"),

            const Divider(height: 30),

            TextField(
              controller: emergency,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Emergency Number",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                if (email == null ||
                    emergency.text.length < 10) {
                  await TtsService.speakHindi(
                      "सही नंबर डालें");
                  return;
                }

                await StorageService.saveEmergency(
                  email!,
                  emergency.text.trim(),
                );

                await TtsService.speakHindi(
                    "नंबर सेव हो गया");
              },
              child: const Text("Save"),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red),
              onPressed: () async {
                await AuthService.logout();
                await StorageService.clearEmail();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
