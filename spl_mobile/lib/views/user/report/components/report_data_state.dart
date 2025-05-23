import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/providers/report/report_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/widgets/snackbar/snackbar_helper.dart';
import 'report_empty_state.dart';

class ReportDataState extends StatefulWidget {
  final List<Report> reports;

  const ReportDataState({super.key, required this.reports});

  @override
  State<ReportDataState> createState() => _ReportDataStateState();
}

class _ReportDataStateState extends State<ReportDataState> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final displayedReports = _showAll
        ? widget.reports
        : widget.reports.take(10).toList();

    return widget.reports.isEmpty
        ? ReportEmptyState()
        : SingleChildScrollView(
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
                    return _buildReportItem(context, report);
                  },
                ),

                if (!_showAll && widget.reports.length > 10)
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
  }

  Widget _buildReportItem(BuildContext context, Report report) {
    final imageUrl = (report.attachments.isNotEmpty)
        ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
        : "";

    return InkWell(
      onTap: () => context.push(AppRoutes.reportDetail, extra: report),
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.green.withOpacity(0.2),
      child: Padding(
        key: ValueKey(report.id),
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _loadingPlaceholder(),
                  errorWidget: (_, __, ___) => _defaultImage(),
                ),
              ),
            if (imageUrl.isNotEmpty) const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title.isNotEmpty ? report.title : "Judul tidak tersedia",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report.village?.isNotEmpty == true
                        ? "${report.village}, ${report.date}"
                        : "${report.date}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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

            if (report.status == "pending")
              IconButton(
                onPressed: () => _confirmDelete(context, report),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
}

  Widget _defaultImage() => Image.asset(
        "assets/images/report/report1.jpg",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );

  void _confirmDelete(BuildContext context, Report report) async {
    final bool? confirm = await showModalBottomSheet<bool>(
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
              const Icon(Icons.delete_outline, size: 50, color: Colors.red),
              const SizedBox(height: 12),
              const Text("Hapus Laporan?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Laporan yang dihapus tidak dapat dikembalikan. Apakah Anda yakin ingin melanjutkan?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
    );

    if (confirm == true && context.mounted) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      final success = await reportProvider.deleteReport(report.id.toString());

      if (success) {
        SnackbarHelper.showSnackbar(context, "Laporan berhasil dihapus");
      } else {
        SnackbarHelper.showSnackbar(context, "Gagal menghapus laporan", isError: true);
      }
    }
  }
}
