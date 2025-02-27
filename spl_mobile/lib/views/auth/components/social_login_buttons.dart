import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🧭 Divider dengan teks "Atau"
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

        /// 🔑 Tombol "Masuk dengan Google" full width
        SizedBox(
          width: double.infinity, // ✅ Full width tombol
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Tambahkan integrasi login Google
            },
            icon: Image.asset('assets/images/google.png', height: 24),
            label: const Text(
              "Masuk dengan Google",
              style: TextStyle(fontSize: 16, color: Color(0xFF6c757d)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF6c757d)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(const Color.fromRGBO(227, 233, 250, 1)),
            ),
          ),
        ),
      ],
    );
  }
}
