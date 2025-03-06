import 'package:flutter/material.dart';

class ReportDetailImage extends StatelessWidget {
  final String? imageUrl;

  const ReportDetailImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300], // Placeholder warna abu-abu
                  child: const Center(
                    child: CircularProgressIndicator(), // Loading indikator
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/default.jpg",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                );
              },
            )
          : Image.asset(
              "assets/images/default.jpg",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
    );
  }
}
