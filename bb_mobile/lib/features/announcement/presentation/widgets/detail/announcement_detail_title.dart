import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementTitle extends StatelessWidget {
  final String title;
  final DateTime createdAt;

  const AnnouncementTitle({
    super.key,
    required this.title,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    // Konversi ke zona waktu WIB (+7 jam dari UTC)
    final wibTime = createdAt.toUtc().add(const Duration(hours: 7));

    // Format dalam 24 jam tanpa AM/PM
    final formattedDate = DateFormat('d MMMM yyyy • HH:mm', 'id_ID').format(wibTime) + ' WIB';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          "Diunggah pada $formattedDate",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
