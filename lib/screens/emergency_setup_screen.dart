import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';

class EmergencySetupScreen extends StatefulWidget {
  const EmergencySetupScreen({super.key});

  @override
  State<EmergencySetupScreen> createState() =>
      _EmergencySetupScreenState();
}

class _EmergencySetupScreenState extends State<EmergencySetupScreen> {
  final controller = TextEditingController();

  Future<void> save() async {
    final email = await StorageService.getEmail();
    if (email == null) return;

    if (controller.text.length < 10) {
      await TtsService.speakHindi("सही नंबर डालें");
      return;
    }

    await StorageService.saveEmergency(email, controller.text.trim());
    await TtsService.speakHindi("नंबर सेव हो गया");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Number")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
