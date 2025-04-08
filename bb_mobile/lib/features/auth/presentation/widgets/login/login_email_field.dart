import 'package:flutter/material.dart';
import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';

class LoginEmailField extends StatelessWidget {
  final TextEditingController controller;

  const LoginEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'Email atau Nomor Telepon',
      icon: Icons.person_outline,
      keyboardType: TextInputType.text,
      validator: Validators.validateEmailOrPhone,
    );
  }
}
