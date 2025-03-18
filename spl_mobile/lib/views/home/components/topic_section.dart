import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/providers/user_report_provider.dart';
import 'dart:math';
import '../../../widgets/custom_chip.dart';

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
                report.title.isNotEmpty 
              ).toList();

              if (validReports.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "📭 Tidak ada topik aduan tersedia.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                );
              }

              // Urutkan berdasarkan likes terbanyak (descending)
              validReports.sort((a, b) => (b.likes ?? 0).compareTo(a.likes ?? 0));

              // Cek apakah semua laporan memiliki 0 likes
              bool allZeroLikes = validReports.every((report) => (report.likes ?? 0) == 0);

              if (allZeroLikes) {
                validReports.shuffle(Random()); // Jika semua likes 0, acak urutannya
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
                          context.push('/report-detail', extra: report);
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
