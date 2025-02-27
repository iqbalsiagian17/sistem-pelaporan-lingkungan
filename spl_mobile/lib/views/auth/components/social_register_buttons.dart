import 'package:flutter/material.dart';
import '../login_view.dart';

class SocialRegisterButtons extends StatelessWidget {
  const SocialRegisterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🧭 Divider dengan tulisan "Atau"
        Row(
          children: const [
            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Atau", style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),

        // 🔑 Tombol Daftar dengan Google
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Integrasikan daftar dengan Google
            },
            icon: Image.asset('assets/images/google.png', height: 24),
            label: const Text(
              "Daftar dengan Google",
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 🔗 Navigasi ke halaman login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sudah punya akun?"),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
              child: const Text(
                "Masuk",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2), // 🔵 Warna teks sesuai tema
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
