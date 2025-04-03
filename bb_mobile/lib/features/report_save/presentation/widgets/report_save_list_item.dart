import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';
import 'package:bb_mobile/features/report_save/presentation/widgets/report_save_delete_modal.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportSaveListItem extends ConsumerWidget {
  final ReportSaveEntity report;
  final int index;

  const ReportSaveListItem({
    super.key,
    required this.report,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        context.push('/report-detail', extra: {"type": "saved", "data": report});
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
                placeholder: (_, __) =>
                    Container(width: 70, height: 70, color: Colors.grey[300]),
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
              onPressed: () {
                showDeleteSavedReportModal(context, ref, report.reportId);
              },
              icon: const Icon(Icons.bookmark, color: Colors.green, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
