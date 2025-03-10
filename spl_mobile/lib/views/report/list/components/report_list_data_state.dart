import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import './report_list_empety.dart';

class ReportSaveDataState extends StatelessWidget {
  final List<Report> reports;
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.reports, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Filter laporan hanya yang memiliki status 'verified', 'in_progress', 'completed', 'closed'
    final filteredReports = reports.where((report) =>
        ['verified', 'in_progress', 'completed', 'closed'].contains(report.status)).toList();

    return filteredReports.isEmpty
        ? ReportListAllEmptyState(onRetry: onRetry)
        : ListView.builder(
            itemCount: filteredReports.length,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (context, index) {
              final report = filteredReports[index];

              // ✅ Ambil base URL dari ApiConstants untuk gambar laporan
              String imageUrl = (report.attachments.isNotEmpty)
                  ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                  : "";

              return InkWell(
                onTap: () {
                  context.push(AppRoutes.reportDetail, extra: report);
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
                              report.title.isNotEmpty ? report.title : "Judul tidak tersedia",
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

                      IconButton(
                        onPressed: () {
                          // TODO: Implementasi fitur bookmark
                        },
                        icon: const Icon(Icons.bookmark_border, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
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
