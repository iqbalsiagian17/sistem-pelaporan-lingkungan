import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_report_list.dart';
import '../../../../providers/report/report_save_provider.dart';
import '../../../../models/ReportSave.dart';
import './report_save_empty_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/routes/app_routes.dart';

class ReportSaveDataState extends StatefulWidget {
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.onRetry});

  @override
  State<ReportSaveDataState> createState() => _ReportSaveDataStateState();
}


class _ReportSaveDataStateState extends State<ReportSaveDataState> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportSaveProvider>(
      builder: (context, reportSaveProvider, child) {
        if (reportSaveProvider.isLoading) {
          return ListView.builder(
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (_, __) => const SkeletonReportList(),
          );
        }

        if (reportSaveProvider.errorMessage != null) {
          return Center(child: Text("❌ ${reportSaveProvider.errorMessage}"));
        }

        final savedReports = reportSaveProvider.savedReports;

        if (savedReports.isEmpty) {
          return ReportSaveEmptyState();
        }

        final displayedReports = _showAll ? savedReports : savedReports.take(10).toList();

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                itemCount: displayedReports.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                itemBuilder: (context, index) {
                  final report = displayedReports[index];
                  return _buildReportCard(report, index, context);
                },
              ),

              if (!_showAll && savedReports.length > 10)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showAll = true),
                    icon: const Icon(Icons.expand_more),
                    label: const Text("Lihat Semua"),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportCard(ReportSave report, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoutes.reportDetail,
          extra: {"type": "saved", "data": report},
        );
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.green.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 12.0 : 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: report.imageUrl.isNotEmpty
                    ? report.imageUrl
                    : "assets/images/default.jpg",
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 70, height: 70, color: Colors.grey[300]),
                errorWidget: (_, __, ___) =>
                    Image.asset("assets/images/default.jpg", width: 70, height: 70),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${report.location}, ${report.date}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: StatusUtils.getStatusColor(report.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      StatusUtils.getTranslatedStatus(report.status),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () => _confirmDelete(context, report),
              icon: const Icon(Icons.bookmark, color: Colors.green, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ReportSave report) async {
    final confirm = await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_remove, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text("Hapus Laporan Tersimpan?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Laporan ini akan dihapus dari daftar tersimpan.",
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Batal", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;

    if (confirm && context.mounted) {
      await Provider.of<ReportSaveProvider>(context, listen: false)
          .deleteSavedReport(report.reportId);
    }
  }
}
