import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';

class LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginSubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "Masuk",
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
      isOutlined: false,
      textColor: Colors.white,
    );
  }
}
