import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/register_view.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboardingCompleted');

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Onboarding direset. Restart aplikasi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Belum punya akun?"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterView()),
                );
              },
              child: const Text("Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        TextButton(
          onPressed: () => _resetOnboarding(context),
          child: const Text("Reset Onboarding"),
        ),
      ],
    );
  }
}
