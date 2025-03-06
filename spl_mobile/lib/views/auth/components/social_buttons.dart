import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onGoogleSignIn; // ⬅️ Tidak lagi "required"

  const SocialButtons({
    super.key,
    this.isLoading = false,
    this.onGoogleSignIn, // ⬅️ Bisa null, tidak wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onGoogleSignIn, // ✅ Tetap aman meskipun null
            icon: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset('assets/images/google.png', height: 24),
            label: Text(
              isLoading ? "Sedang masuk..." : "Masuk dengan Google",
              style: const TextStyle(fontSize: 16, color: Color(0xFF6c757d)),
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
