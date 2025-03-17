import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/providers/report_save_provider.dart';
import 'package:spl_mobile/providers/user_report_likes_provider.dart';

class ReportDetailStatus extends StatelessWidget {
  final int reportId;
  final String? status;
  final String token; // ✅ Tambahkan token untuk API

  const ReportDetailStatus({
    super.key,
    required this.reportId,
    required this.token,
    this.status,
  });

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
              color: Colors.white, // ✅ Pastikan teks terlihat jelas
            ),
          ),
        ),

        Row(
          children: [
            // ❤️ **Tombol Like**
            Consumer<ReportLikeProvider>(
              builder: (context, likeProvider, child) {
                bool isLiked = likeProvider.isLiked(reportId);

                return IconButton(
                  onPressed: () async {
                    if (isLiked) {
                      await likeProvider.unlikeReport(reportId, token);
                    } else {
                      await likeProvider.likeReport(reportId, token);
                    }
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                );
              },
            ),

            // 🔖 **Tombol Bookmark (Simpan/Hapus)**
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
