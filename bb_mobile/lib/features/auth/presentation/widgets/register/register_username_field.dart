import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/core/utils/validators.dart';

class RegisterUsernameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const RegisterUsernameField({
    super.key,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'Username',
      icon: Icons.person,
      validator: Validators.validateNotEmpty,
      errorText: errorText,
    );
  }
}
