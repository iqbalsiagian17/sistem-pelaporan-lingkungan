import 'package:flutter/material.dart';

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
        const SizedBox(height: 24),
        _buildDividerWithText("Atau"),
        const SizedBox(height: 16),

        // Google only (centered)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              imageAsset: 'assets/images/google.png',
              onPressed: isLoading ? null : onGoogleSignIn,
              isLoading: isLoading,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    IconData? icon,
    Color? color,
    String? imageAsset,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 38,
        width: 38,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : imageAsset != null
                ? Image.asset(imageAsset)
                : Icon(icon, color: color, size: 20),
      ),
    );
  }
}
