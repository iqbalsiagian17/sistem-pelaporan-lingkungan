import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportListItem extends StatelessWidget {
  final ReportEntity report;

  const ReportListItem({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = report.attachments.isNotEmpty
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
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/report/report1.jpg",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
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
                    report.village?.isNotEmpty == true
                        ? "${report.village}, ${report.date}"
                        : report.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
          ],
        ),
      ),
    );
  }
}
