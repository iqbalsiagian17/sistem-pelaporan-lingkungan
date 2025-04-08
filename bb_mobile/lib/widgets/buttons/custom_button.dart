import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool isOutlined; // Support for Outlined Button
  final Color borderColor;
  final Widget? icon; // Support for icon

  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.onPressed,
    this.color = const Color(0xFF4CAF50), // Default color for the button
    this.textColor = Colors.white, // Default text color
    this.isOutlined = false, // Default to non-outlined button
    this.borderColor = Colors.grey, // Default border color (same as input field)
    this.icon, // Icon support
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: icon ?? const SizedBox(), // Add icon if provided
              label: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      text,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                    ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: borderColor), // Border color for Outlined Button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(textColor.withOpacity(0.1)),
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color, // Button color
                foregroundColor: textColor, // Text color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: borderColor), // Border color for ElevatedButton
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      text,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
    );
  }
}
