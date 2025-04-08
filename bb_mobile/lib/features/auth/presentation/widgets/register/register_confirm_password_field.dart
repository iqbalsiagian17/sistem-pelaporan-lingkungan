import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';

class RegisterConfirmPasswordField extends StatelessWidget {
  final TextEditingController confirmPasswordController;
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback onToggleObscure;

  const RegisterConfirmPasswordField({
    super.key,
    required this.confirmPasswordController,
    required this.passwordController,
    required this.isObscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: confirmPasswordController,
      label: 'Konfirmasi Password',
      icon: Icons.lock_outline,
      isObscure: isObscure,
      onToggleObscure: onToggleObscure,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
        if (value != passwordController.text) return 'Password tidak cocok';
        return null;
      },
    );
  }
}
