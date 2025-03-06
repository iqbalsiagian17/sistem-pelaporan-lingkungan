import 'package:flutter/material.dart';

class ReportTextField extends StatelessWidget {
  final String title;
  final String hint;
  final int maxLines;
  final TextEditingController? controller; // ✅ Tambahkan controller

  const ReportTextField({
    super.key,
    required this.title,
    required this.hint,
    this.maxLines = 1,
    this.controller, // ✅ Gunakan controller jika tersedia

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          controller: controller, // ✅ Gunakan controller untuk mengelola input
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
