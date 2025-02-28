import 'package:flutter/material.dart';

class ReportDetailImage extends StatelessWidget {
  final String? imageUrl;

  const ReportDetailImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imageUrl ?? "assets/images/default.jpg",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
