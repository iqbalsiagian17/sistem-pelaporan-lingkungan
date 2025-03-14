import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/status_utils.dart'; // Import helper class
import 'package:spl_mobile/providers/report_save_provider.dart';

class ReportDetailStatus extends StatelessWidget {
  final int reportId;
  final String? status;

  const ReportDetailStatus({super.key, required this.reportId, this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Ratakan antara status & tombol
      children: [
        // 🔹 Status Aduan
        Container(
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
        ),

        Row(
          children: [
            // ❤️ Tombol Like (Kosongan Dulu)
            IconButton(
              onPressed: () {
                // TODO: Implementasi fitur like
              },
              icon: const Icon(Icons.favorite_border, color: Colors.red),
            ),

            // 🔖 Tombol Bookmark (Simpan/Hapus)
            Consumer<ReportSaveProvider>(
              builder: (context, reportSaveProvider, child) {
                bool isSaved = reportSaveProvider.isReportSaved(reportId);

                return IconButton(
                  onPressed: () async {
                    if (isSaved) {
                      await reportSaveProvider.deleteSavedReport(reportId);
                    } else {
                      await reportSaveProvider.saveReport(reportId);
                    }
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.green : Colors.black54,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
