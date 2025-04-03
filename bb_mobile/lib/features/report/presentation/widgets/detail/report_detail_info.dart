import 'package:flutter/material.dart';

class ReportDetailInfo extends StatelessWidget {
  final String? reportNumber;
  final String? createdAt;

  const ReportDetailInfo({
    super.key,
    this.reportNumber,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ Full width agar sejajar dengan elemen lain
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // ✅ Border radius agar tampilan smooth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // ✅ Padding agar lebih proporsional
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Nomor Aduan
            Text(
              "Nomor Aduan: ${reportNumber ?? '-'}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            // 🔹 Tanggal Dibuat
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  createdAt ?? "Tanggal tidak tersedia",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
