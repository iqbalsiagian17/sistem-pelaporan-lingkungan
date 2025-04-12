import 'package:flutter/material.dart';

class AnnouncementListEmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const AnnouncementListEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/report/empty_report.png', 
              height: 180,
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada pengumuman',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Saat ini belum ada pengumuman yang tersedia. Silakan cek kembali nanti.',
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
