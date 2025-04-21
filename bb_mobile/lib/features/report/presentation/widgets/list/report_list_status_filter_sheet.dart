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
      {'label': 'Ditolak', 'value': 'rejected'},
      {'label': 'Dibatalkan', 'value': 'canceled'},
      // Tambah status lain pun aman, tetap scrollable
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
          Flexible( // ✅ Flexible agar tidak error jika bottom sheet kecil
            child: SingleChildScrollView(
              child: Column(
                children: statuses.map((status) {
                  final selected = selectedStatus == status['value'];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(status['label']!),
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      onStatusSelected(status['value']!);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
