import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/core/utils/validators.dart';

class RegisterPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const RegisterPhoneField({
    super.key,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      label: 'Nomor Telepon',
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: Validators.validatePhone,
      errorText: errorText,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }
}
