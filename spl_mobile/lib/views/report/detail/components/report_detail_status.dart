import 'package:flutter/material.dart';

class ReportDetailStatus extends StatelessWidget {
  final String? status;

  const ReportDetailStatus({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status ?? "Status tidak diketahui",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
