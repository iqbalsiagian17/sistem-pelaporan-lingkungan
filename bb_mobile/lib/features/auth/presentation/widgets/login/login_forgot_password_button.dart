import 'package:bb_mobile/features/auth/presentation/widgets/otp/forgot_password_modal.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          'Lupa Password?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
