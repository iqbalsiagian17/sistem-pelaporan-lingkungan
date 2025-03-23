import 'package:flutter/material.dart';

class ReportEmptyState extends StatelessWidget {
  const ReportEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/report/empty_report.png', // Pastikan gambar tersedia
            height: 200,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada aduan',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
