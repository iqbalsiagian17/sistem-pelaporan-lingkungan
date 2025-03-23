import 'package:flutter/material.dart';

class ReportSaveEmptyState extends StatelessWidget {
  const ReportSaveEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/report/empty_report.png', // Pastikan path benar
            height: 180,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada aduan yang disimpan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
