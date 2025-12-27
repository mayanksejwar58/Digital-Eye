import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import 'camera_screen.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {

  static const Color bgPurple = Color(0xFF2A1B3D);
  static const Color cardPurple = Color(0xFF3E2C5C);
  static const Color accentLavender = Color(0xFFE6D9FF);
  static const Color softText = Color(0xFFCEC2E8);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 400), () {
      TtsService.speakHindi(
        "कैमरा स्क्रीन के उपयोग के निर्देश। "
        "एक बार टैप करने पर बैटरी और समय बताया जाएगा। "
        "दो बार टैप करने पर टेक्स्ट पढ़ा जाएगा। "
        "तीन बार टैप करने पर वॉकिंग मोड चालू या बंद होगा। "
        "लंबा दबाने पर आपातकालीन कॉल की जाएगी। "
        "नीचे कहीं भी टैप करने पर कैमरा चालू हो जाएगा।"
      );
    });
  }

  Widget _tile(String title, String desc, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: accentLavender),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: accentLavender,
        ),
      ),
      subtitle: Text(
        desc,
        style: const TextStyle(color: softText),
      ),
    );
  }

  void _startCamera() {
    TtsService.speakHindi("कैमरा शुरू किया जा रहा है");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPurple,
      appBar: AppBar(
        title: const Text("How to Use"),
        backgroundColor: bgPurple,
        foregroundColor: accentLavender,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          _tile("Single Tap", "बैटरी और समय सुने", Icons.touch_app),
          _tile("Double Tap", "कैमरा से टेक्स्ट पढ़ें", Icons.menu_book),
          _tile("Triple Tap", "Walking Mode चालू / बंद करें", Icons.directions_walk),
          _tile("Long Press", "SOS आपातकालीन कॉल", Icons.warning_amber),
          _tile("Settings Button", "Emergency नंबर और Logout", Icons.settings),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _startCamera,
              child: Container(
                width: double.infinity,
                color: cardPurple,
                alignment: Alignment.center,
                child: const Text(
                  "यहाँ टैप करें",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: accentLavender,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
