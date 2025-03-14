import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/providers/user_report_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../../widgets/custom_chip.dart';
import 'dart:math';

class TopicSection extends StatelessWidget {
  const TopicSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Topik Aduan Populer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              List<Report> validReports = reportProvider.reports.where((report) =>
                ["verified", "in_progress", "completed", "closed"].contains(report.status) &&
                report.title.isNotEmpty // ✅ Pastikan title tidak kosong
              ).toList();

              // Jika tidak ada laporan, tampilkan teks kosong
              if (validReports.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "📭 Tidak ada topik aduan tersedia.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                );
              }

              // Urutkan berdasarkan likes terbanyak
              validReports.sort((a, b) => (b.likes ?? 0).compareTo(a.likes ?? 0));

              // Jika tidak ada laporan yang memiliki likes, ambil 5 laporan secara acak
              if (validReports.every((report) => report.likes == 0)) {
                validReports.shuffle(Random());
              }

              // Ambil hanya 5 laporan teratas
              List<Report> topReports = validReports.take(5).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: topReports.map((report) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          try {
                            GoRouter.of(context).push(
                              AppRoutes.reportDetail, // ✅ Pastikan cocok dengan GoRoute
                              extra: report, // ✅ Kirim data laporan
                            );
                          } catch (e) {
                            print("❌ Error navigasi ke report-detail: $e");
                          }
                        },
                        child: CustomChip(label: "#${report.title}"),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
