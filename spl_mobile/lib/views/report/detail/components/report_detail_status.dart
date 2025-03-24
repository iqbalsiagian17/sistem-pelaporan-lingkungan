import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/providers/report/report_save_provider.dart';
import 'package:spl_mobile/providers/report/report_likes_provider.dart';

class ReportDetailStatus extends StatefulWidget {
  final int reportId;
  final String? status;
  final String token;
  final int likes; // ✅ Ambil nilai awal likes dari backend (t_report.likes)

  const ReportDetailStatus({
    super.key,
    required this.reportId,
    required this.token,
    required this.likes,
    this.status,
  });

  @override
  _ReportDetailStatusState createState() => _ReportDetailStatusState();
}

class _ReportDetailStatusState extends State<ReportDetailStatus> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReportLikeProvider>(context, listen: false)
          .fetchLikeCount(widget.reportId, widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🔹 **Status Aduan**
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: StatusUtils.getStatusColor(widget.status),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            StatusUtils.getTranslatedStatus(widget.status),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Row(
          children: [
            // ❤️ **Tombol Like & Jumlah Likes**
            Consumer<ReportLikeProvider>(
              builder: (context, likeProvider, child) {
                bool isLiked = likeProvider.isLiked(widget.reportId);
                int likeCount =
                    likeProvider.getLikeCount(widget.reportId) > 0
                        ? likeProvider.getLikeCount(widget.reportId)
                        : widget.likes; // ✅ Gunakan nilai awal dari database

                return Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (isLiked) {
                          await likeProvider.unlikeReport(widget.reportId, widget.token);
                        } else {
                          await likeProvider.likeReport(widget.reportId, widget.token);
                        }
                      },
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(
                      "$likeCount", // ✅ Tampilkan jumlah likes dari database atau API
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              },
            ),

            // 🔖 **Tombol Bookmark (Simpan/Hapus)**
            Consumer<ReportSaveProvider>(
              builder: (context, reportSaveProvider, child) {
                bool isSaved = reportSaveProvider.isReportSaved(widget.reportId);

                return IconButton(
                  onPressed: () async {
                    if (isSaved) {
                      await reportSaveProvider.deleteSavedReport(widget.reportId);
                    } else {
                      await reportSaveProvider.saveReport(widget.reportId);
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
