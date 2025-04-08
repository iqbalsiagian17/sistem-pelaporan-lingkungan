import 'package:flutter/material.dart';

class LoginForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginForgotPasswordButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed ?? () {
          // TODO: Arahkan ke halaman lupa password jika sudah dibuat
          debugPrint("🔐 Navigasi ke halaman Lupa Password (belum diimplementasi)");
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
