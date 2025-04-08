import 'package:flutter/material.dart';

class RegisterTermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onShowTerms;

  const RegisterTermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onShowTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Flexible(
          child: Wrap(
            children: [
              Text(
                'Saya setuju dengan ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              GestureDetector(
                onTap: onShowTerms,
                child: Text(
                  'Syarat & Ketentuan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
