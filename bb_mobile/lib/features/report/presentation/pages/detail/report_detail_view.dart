import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/report/data/models/report_evidence_model.dart';
import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/data/models/report_status_history_model.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/rating_bottom_sheet.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_admin_comment.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_description.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_image.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_info.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_location.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_status.dart';
import 'package:bb_mobile/features/report/presentation/widgets/detail/report_detail_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ReportDetailView extends ConsumerWidget {
  final ReportModel report;

  const ReportDetailView({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Tampilkan modal rating otomatis jika statusnya 'completed'
  if (report.status == 'completed') {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await ref
          .read(reportProvider.notifier)
          .getRating(report.id); // Cek apakah user sudah kasih rating

      if (result == null && context.mounted) {
        // Belum ada rating, tampilkan modal
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => RatingBottomSheet(reportId: report.id),
        );
      }
    });
  }

  
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ReportDetailTopBar(title: "Detail Laporan"),
body: SingleChildScrollView(
  padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Gambar & Info Dasar
            Container(
              decoration: _boxShadow(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ReportDetailImage(
                      imageUrls: report.attachments.isNotEmpty
                          ? report.attachments.map((e) => "${ApiConstants.baseUrl}/${e.file}").toList()
                          : ["assets/images/default.jpg"],
                      reportId: report.id,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReportDetailStatus(
                            reportId: report.id,
                            status: report.status,
                            total_likes: report.total_likes,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            report.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ReportDetailDescription(description: report.description),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Info Laporan
            Container(
              decoration: _boxShadow(),
              child: ReportDetailInfo(
                reportNumber: report.reportNumber,
                createdAt: report.date,
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Lokasi
            Container(
              decoration: _boxShadow(),
              child: ReportDetailLocation(
                latitude: report.latitude,
                longitude: report.longitude,
                village: report.village,
                locationDetails: report.locationDetails,
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Riwayat Status & Bukti
            if (report.statusHistory.isNotEmpty)
              ReportDetailStatusHistory(
                statusHistory: report.statusHistory
                    .map((e) => ReportStatusHistoryModel.fromEntity(e))
                    .toList(),
                evidences: report.evidences
                    .map((e) => ReportEvidenceModel.fromEntity(e))
                    .toList(),
                status: report.status,
              )
            else
              _noAdminResponseCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxShadow() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _noAdminResponseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Color(0xFF66BB6A), size: 36),
          SizedBox(height: 12),
          Text(
            "Belum ada tanggapan dari admin",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            "Silakan tunggu beberapa saat, admin akan segera menanggapi laporan Anda.",
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
