import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report_save/presentation/providers/report_save_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportDetailStatus extends ConsumerStatefulWidget {
  final int reportId;
  final String? status;
  final int total_likes;

  const ReportDetailStatus({
    super.key,
    required this.reportId,
    required this.total_likes,
    this.status,
  });

  @override
  ConsumerState<ReportDetailStatus> createState() => _ReportDetailStatusState();
}

class _ReportDetailStatusState extends ConsumerState<ReportDetailStatus> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reportProvider.notifier).fetchLikeStatus(widget.reportId);
      ref.read(reportProvider.notifier).fetchLikeCount(widget.reportId);
      ref.read(reportSaveNotifierProvider.notifier).fetchSavedReports();
    });
  }

@override
Widget build(BuildContext context) {
final reportState = ref.watch(reportProvider);
final likeNotifier = ref.read(reportProvider.notifier);
  final saveState = ref.watch(reportSaveNotifierProvider);
  final saveNotifier = ref.read(reportSaveNotifierProvider.notifier);
final isLiked = reportState is AsyncData &&
    likeNotifier.likedReportIds.contains(widget.reportId);

final likeCount = likeNotifier.likeCounts[widget.reportId] ?? widget.total_likes;

  final isSaved = saveState.maybeWhen(
    data: (savedReports) =>
        savedReports.any((report) => report.reportId == widget.reportId),
    orElse: () => false,
  );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🔹 Status Aduan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: StatusUtils.getStatusColor(widget.status),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            StatusUtils.getTranslatedStatus(widget.status),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Row(
          children: [
            // ❤️ Like Button + Count
            IconButton(
              onPressed: () async {
                if (isLiked) {
                  await likeNotifier.unlikeReport(widget.reportId);
                } else {
                  await likeNotifier.likeReport(widget.reportId);
                }
              },
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
            ),
            Text(
              "$likeCount",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),

            IconButton(
              onPressed: () async {
                if (isSaved) {
                  await saveNotifier.deleteSavedReport(widget.reportId);
                  if (context.mounted) {
                    SnackbarHelper.showSnackbar(
                      context,
                      "Laporan dihapus dari tersimpan", 
                    );
                  }
                } else {
                  await saveNotifier.saveReport(widget.reportId);
                  if (context.mounted) {
                    SnackbarHelper.showSnackbar(
                      context,
                      "Laporan berhasil disimpan",
                    );
                  }
                }
              },
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? const Color(0xFF66BB6A) : Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
