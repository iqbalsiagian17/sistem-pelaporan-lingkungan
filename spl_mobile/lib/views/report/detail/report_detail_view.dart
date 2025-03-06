import 'package:flutter/material.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/models/Report.dart';
import 'components/report_detail_topbar.dart';
import 'components/report_detail_image.dart';
import 'components/report_detail_status.dart';
import 'components/report_detail_description.dart';
import 'components/report_detail_info.dart';
import 'components/report_detail_admin_comment.dart';

class ReportDetailView extends StatelessWidget {
  final Report report;

  const ReportDetailView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // 🔥 Debugging sebelum UI ditampilkan
    print("🔥 Debugging statusHistory: ${report.statusHistory}");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ReportDetailTopBar(title: "Detail Laporan"),
      body: Container(
        color: Colors.white, // ✅ Background utama tetap putih
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // 🔹 Kartu berisi gambar & informasi dasar laporan
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReportDetailImage(
                          imageUrl: (report.attachments.isNotEmpty && report.attachments.first.file.isNotEmpty)
                              ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                              : "assets/images/default.jpg",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReportDetailStatus(status: report.status),
                              const SizedBox(height: 10),
                              Text(
                                report.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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

                // 🔹 Informasi Detail Laporan
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ReportDetailInfo(
                    reportNumber: report.reportNumber,
                    createdAt: report.date,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Riwayat Perubahan Status (Jika Ada)
                if (report.statusHistory.isNotEmpty) ...[
                  ReportDetailStatusHistory(statusHistory: report.statusHistory),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100], // 🔥 Efek Gradient
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 600),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.warning_amber_rounded, 
                                  color: Colors.green, 
                                  size: 36), // 🔹 Ikon Peringatan
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Belum ada tanggapan dari admin",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Silakan tunggu beberapa saat, admin akan segera menanggapi laporan Anda.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      );
  }
}
