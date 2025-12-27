import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'camera_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Login with Google"),
          onPressed: () async {
            final email = await AuthService.login();
            if (email != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CameraScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
