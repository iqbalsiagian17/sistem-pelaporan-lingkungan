import 'package:flutter/material.dart';

class ReportStatusFilterBottomSheet extends StatelessWidget {
  final String selectedStatus;
  final Function(String status) onStatusSelected;

  const ReportStatusFilterBottomSheet({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {'label': 'Semua Status', 'value': 'all'},
      {'label': 'Terverifikasi', 'value': 'verified'},
      {'label': 'Diproses', 'value': 'in_progress'},
      {'label': 'Selesai', 'value': 'completed'},
      {'label': 'Ditutup', 'value': 'closed'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Filter Status Laporan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...statuses.map((status) {
            final selected = selectedStatus == status['value'];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(status['label']!),
              trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                onStatusSelected(status['value']!);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}
