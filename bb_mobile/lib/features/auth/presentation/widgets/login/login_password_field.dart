import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/core/utils/validators.dart';

class LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscure;
  final VoidCallback onToggleObscure;

  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.isObscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'Kata Sandi',
      icon: Icons.lock_outline,
      isObscure: isObscure,
      onToggleObscure: onToggleObscure,
      validator: Validators.validatePassword,
    );
  }
}
