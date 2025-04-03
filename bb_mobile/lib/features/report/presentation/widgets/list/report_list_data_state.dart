import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_empty_state.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ReportListDataState extends StatefulWidget {
  final List<ReportEntity> reports;
  final VoidCallback onRetry;

  const ReportListDataState({
    super.key,
    required this.reports,
    required this.onRetry,
  });

  @override
  State<ReportListDataState> createState() => _ReportListDataStateState();
}

class _ReportListDataStateState extends State<ReportListDataState> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final filteredReports = widget.reports
        .where((report) =>
            ['verified', 'in_progress', 'completed', 'closed']
                .contains(report.status))
        .toList();

    if (filteredReports.isEmpty) {
      return ReportListAllEmptyState(onRetry: widget.onRetry);
    }

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
              final imageUrl = (report.attachments.isNotEmpty)
                  ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                  : "";

              return InkWell(
                onTap: () {
context.push(AppRoutes.detailReport, extra: report);
                 },
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
                              "${report.village?.isNotEmpty == true ? report.village : report.locationDetails ?? "Lokasi tidak tersedia"}, ${report.date.isNotEmpty ? report.date : "Tanggal tidak diketahui"}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    StatusUtils.getStatusColor(report.status),
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
                        onPressed: () {
                          // TODO: Bookmark
                        },
                        icon: const Icon(Icons.bookmark_border,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 🔽 Tombol "Lihat Semua" jika data lebih dari 10
          if (!_showAll && filteredReports.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton.icon(
                onPressed: () => setState(() => _showAll = true),
                icon: const Icon(Icons.expand_more),
                label: const Text("Lihat Semua"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
            ),
        ],
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


  Widget _defaultImage() {
    return Image.asset(
      "assets/images/report/report1.jpg",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
}
