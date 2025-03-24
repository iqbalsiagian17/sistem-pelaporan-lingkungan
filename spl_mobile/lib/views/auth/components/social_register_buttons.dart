import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/buttons/custom_button.dart';

class SocialRegisterButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onGoogleSignUp;

  const SocialRegisterButtons({
    super.key,
    this.isLoading = false,
    this.onGoogleSignUp,
  });

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

        /// 🔑 Tombol "Daftar dengan Google"
        CustomButton(
          text: isLoading ? "Sedang mendaftar..." : "Daftar dengan Google",
          isLoading: isLoading,
          isOutlined: true,
          textColor: const Color(0xFF6c757d),
          borderColor: const Color(0xFF6c757d),
          onPressed: isLoading ? null : onGoogleSignUp,
          icon: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Image.asset('assets/images/google.png', height: 24),
        ),

        const SizedBox(height: 24),

        /// 🔗 **Navigasi ke halaman Login menggunakan `GoRouter`**
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sudah punya akun?"),
            TextButton(
              onPressed: () => context.go(AppRoutes.login), // ✅ **Gunakan GoRouter**
              child: const Text(
                "Masuk",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
