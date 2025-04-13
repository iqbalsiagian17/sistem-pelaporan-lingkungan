import 'package:flutter/material.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';

class SocialButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onGoogleSignIn;

  const SocialButtons({
    super.key,
    this.isLoading = false,
    this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDividerWithText("Atau"),
        const SizedBox(height: 16),

        /// ✅ Tombol Google dengan CustomButton
        CustomButton(
          text: "Masuk dengan Google",
          onPressed: isLoading ? null : onGoogleSignIn,
          isLoading: isLoading,
          isOutlined: true,
          textColor: Colors.black87,
          borderColor: Colors.grey.shade300,
          icon: Image.asset(
            'assets/images/google.png',
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5, color: Colors.grey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(text, style: const TextStyle(color: Colors.grey)),
        ),
        const Expanded(child: Divider(thickness: 0.5, color: Colors.grey)),
      ],
    );
  }
}
