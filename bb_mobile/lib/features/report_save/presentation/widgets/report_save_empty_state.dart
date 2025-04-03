import 'package:flutter/material.dart';

class ReportSaveEmptyState extends StatelessWidget {
  const ReportSaveEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/report/empty_report.png', // ✅ Pastikan path gambar sesuai
              height: 180,
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada laporan yang disimpan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan laporan penting agar mudah diakses kembali.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
