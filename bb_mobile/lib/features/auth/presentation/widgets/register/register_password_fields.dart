import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/core/utils/validators.dart';

class RegisterPasswordFields extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback onToggleObscure;

  const RegisterPasswordFields({
    super.key,
    required this.passwordController,
    required this.isObscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: passwordController,
      label: 'Password',
      icon: Icons.lock,
      isObscure: isObscure,
      onToggleObscure: onToggleObscure,
      validator: Validators.validatePassword,
    );
  }
}
