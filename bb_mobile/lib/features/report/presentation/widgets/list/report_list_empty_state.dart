import 'package:flutter/material.dart';

class ReportListAllEmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const ReportListAllEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/report/empty_report.png', height: 200),
          const SizedBox(height: 16),
          const Text('Belum ada aduan', style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
