import 'package:bb_mobile/features/auth/presentation/widgets/otp/forgot_password_modal.dart';
import 'package:flutter/material.dart';

class LoginForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginForgotPasswordButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
      onPressed: onPressed ??
          () {
            debugPrint("📩 Membuka modal lupa password");
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => const ForgotPasswordBottomSheet(),
            );
          },
        child: const Text(
          'Lupa Kata Sandi?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF66BB6A),
          ),
        ),
      ),
    );
  }
}
