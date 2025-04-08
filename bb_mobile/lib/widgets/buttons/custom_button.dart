import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool isOutlined;
  final Color borderColor;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.onPressed,
    this.color = const Color(0xFF66BB6A),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.borderColor = Colors.grey,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final childContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          );

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                overlayColor: MaterialStateProperty.all(textColor.withOpacity(0.08)),
              ),
              child: childContent,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.08)),
              ),
              child: childContent,
            ),
    );
  }
}
