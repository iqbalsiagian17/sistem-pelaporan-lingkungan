import 'package:flutter/material.dart';

class ReportTextField extends StatelessWidget {
  final String title;
  final String hint;
  final int maxLines;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isRequired; // ✅ Tambahan

  const ReportTextField({
    super.key,
    required this.title,
    required this.hint,
    this.maxLines = 1,
    this.controller,
    this.focusNode,
    this.validator,
    this.isRequired = false, // ✅ Default false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: isRequired
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
