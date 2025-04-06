import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ReportListDataState extends ConsumerStatefulWidget {
  final List<ReportEntity> reports;
  final VoidCallback onRetry;
  final int currentUserId;

  const ReportListDataState({
    super.key,
    required this.reports,
    required this.onRetry,
    required this.currentUserId,
  });

  @override
  ConsumerState<ReportListDataState> createState() => _ReportListDataStateState();
}

class _ReportListDataStateState extends ConsumerState<ReportListDataState> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final filteredReports = widget.reports
        .where((report) => report.userId == widget.currentUserId)
        .toList();

    final displayReports =
        _showAll ? filteredReports : filteredReports.take(10).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayReports.length,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (context, index) {
              final report = displayReports[index];

                print("Report ID: ${report.id}, status: ${report.status}, user: ${report.userId}");

              final imageUrl = (report.attachments.isNotEmpty)
                  ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                  : "";

              return InkWell(
                onTap: () => context.push(AppRoutes.detailReport, extra: report),
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
                            placeholder: (context, url) => _loadingPlaceholder(),
                            errorWidget: (context, url, error) => _defaultImage(),
                          ),
                        ),
                      if (imageUrl.isNotEmpty) const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title.isNotEmpty
                                  ? report.title
                                  : "Judul tidak tersedia",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              report.village?.isNotEmpty == true
                                  ? "${report.village}, ${report.date}"
                                  : report.date,
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
if (report.status.toLowerCase() == "pending")
                        IconButton(
                          onPressed: () => _confirmDelete(context, report.id),
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (!_showAll && filteredReports.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton.icon(
                onPressed: () => setState(() => _showAll = true),
                icon: const Icon(Icons.expand_more),
                label: const Text("Lihat Semua"),
                style: TextButton.styleFrom(foregroundColor: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int reportId) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "Hapus Aduan?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Aduan yang dihapus tidak dapat dipulihkan.\nYakin ingin menghapus aduan ini?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
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
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Hapus"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await ref.read(reportProvider.notifier).deleteReport(reportId.toString());
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Laporan berhasil dihapus")),
        );
        widget.onRetry(); // Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Gagal menghapus laporan")),
        );
      }
    }
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

  Widget _defaultImage() {
    return Image.asset(
      "assets/images/report/report1.jpg",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
}
