import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

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
        _buildDivider(),
        const SizedBox(height: 16),
        _buildGoogleButton(),
        const SizedBox(height: 24),
        _buildLoginRedirect(context),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Atau", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onGoogleSignUp,
        icon: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Image.asset('assets/images/google.png', height: 24),
        label: Text(
          isLoading ? "Sedang mendaftar..." : "Daftar dengan Google",
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
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sudah punya akun?"),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: const Text(
            "Masuk",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
        ),
      ],
    );
  }
}
