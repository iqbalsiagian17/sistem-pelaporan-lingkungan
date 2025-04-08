import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/input/custom_input_field.dart';
import 'package:bb_mobile/core/utils/validators.dart';

class RegisterEmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String? errorText;

  const RegisterEmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputField(
          controller: controller,
          label: 'Email',
          icon: Icons.email,
          focusNode: focusNode,
          validator: Validators.validateEmail,
          errorText: errorText,
        ),
        if (isFocused)
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 0),
            child: Text(
              "Gunakan email aktif karena kode verifikasi akan dikirim ke email tersebut.",
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
