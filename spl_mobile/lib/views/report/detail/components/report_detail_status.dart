import 'package:flutter/material.dart';
import 'package:spl_mobile/core/utils/status_utils.dart'; // Import helper class

class ReportDetailStatus extends StatelessWidget {
  final String? status;

  const ReportDetailStatus({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: StatusUtils.getStatusColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        StatusUtils.getTranslatedStatus(status),
        style: const TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.bold, 
          color: Colors.white, // Pastikan teks terlihat jelas
        ),
      ),
    );
  }
}
