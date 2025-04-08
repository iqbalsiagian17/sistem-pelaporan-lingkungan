import 'dart:math';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/chip/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TopicSection extends ConsumerWidget {
  const TopicSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportProvider);

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
          reportState.when(
            data: (reports) {
              final validReports = reports.where((report) =>
                  ["verified", "in_progress", "completed", "closed"]
                      .contains(report.status) &&
                  report.title.isNotEmpty).toList();

              if (validReports.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Belum ada topik aduan populer.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }

              validReports.sort((a, b) => (b.likes ?? 0).compareTo(a.likes ?? 0));
              final allZeroLikes = validReports.every((r) => (r.likes ?? 0) == 0);

              if (allZeroLikes) {
                validReports.shuffle(Random());
              }

              final topReports = validReports.take(5).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: topReports.map((report) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.detailReport, extra: report),
                        child: CustomChip(label: "#${report.title}"),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text(" Terjadi kesalahan: $err"),
          ),
        ],
      ),
    );
  }
}
