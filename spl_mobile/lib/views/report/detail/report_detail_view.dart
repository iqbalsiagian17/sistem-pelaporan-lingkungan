import 'package:flutter/material.dart';
import 'components/report_detail_topbar.dart';
import 'components/report_detail_image.dart';
import 'components/report_detail_title.dart';
import 'components/report_detail_status.dart';
import 'components/report_detail_description.dart';
import 'components/report_detail_admin_comment.dart'; // ✅ Import Komentar Admin
import 'components/report_detail_info.dart';

class ReportDetailView extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetailView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReportDetailTopBar(title: "Detail Laporan"), // ✅ Gunakan TopBar
      body: SingleChildScrollView( // ✅ Bungkus seluruh halaman agar bisa di-scroll jika konten panjang
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Bungkus Gambar & Info dalam 1 Container
              Container(
                width: double.infinity, // ✅ Full Width
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
                child: Padding( // ✅ Tambahkan padding hanya untuk konten di dalam Container
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // ✅ Padding lebih proporsional
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReportDetailImage(imageUrl: report["image"]), // 🖼️ Gambar Laporan
                      const SizedBox(height: 5),
                      ReportDetailStatus(status: report["status"]),
                      const SizedBox(height: 16),
                      ReportDetailDescription(description: report["description"]),
                      const SizedBox(height: 5),
                      ReportDetailTitle(
                        title: report["title"], 
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ReportDetailInfo(
                reportNumber: report["report_number"],  // ✅ Pastikan ini ada dalam data
                createdAt: report["created_at"],  // ✅ Pastikan ini ada dalam data
              ),

              const SizedBox(height: 16),

              // ✅ Kolom Komentar Admin (Muncul Jika Status Diubah)
              if (report["admin_comments"] != null && report["admin_comments"] is List) ...[
                ReportDetailAdminComment(adminComments: List<Map<String, String>>.from(report["admin_comments"])),
              ],
            ],
          ),
        ),
      );
  }
}
