import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/features/report_save/presentation/providers/report_save_provider.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/core/constants/api.dart';

class RecentReportsSection extends ConsumerWidget {
  const RecentReportsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        reportState.when(
          loading: () => ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) => _skeletonItem(),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: Text(
                " Terjadi kesalahan: $err",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          data: (reports) {
            final filtered = reports
                .where((r) => ["verified", "in_progress", "completed", "closed"].contains(r.status))
                .take(5)
                .toList();

            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    const Text(
                      "Belum Ada Aduan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Yuk jadi yang pertama menyampaikan aduan!\nKami siap mendengarkan dan menindaklanjuti.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/create-report'),
                      icon: const Icon(Icons.add),
                      label: const Text("Buat Aduan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: filtered.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final report = filtered[index];
                final imageUrl = report.attachments.isNotEmpty
                    ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                    : "";

                return InkWell(
                  onTap: () {
                  context.push(AppRoutes.detailReport, extra: report);

                  },
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Color(0xFF66BB6A).withOpacity(0.2),
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
                                report.title,
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
                        Consumer(
                          builder: (context, ref, _) {
                            final savedReportsState = ref.watch(reportSaveNotifierProvider);
                            final saveNotifier = ref.read(reportSaveNotifierProvider.notifier);

                            final isSaved = savedReportsState.when(
                              data: (savedReports) => savedReports.any((r) => r.reportId == report.id),
                              loading: () => false,
                              error: (_, __) => false,
                            );

                            return IconButton(
                              onPressed: () async {
                                if (isSaved) {
                                  await saveNotifier.deleteSavedReport(report.id);
                                  if (context.mounted) {
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      "Laporan dihapus dari tersimpan",
                                    );
                                  }
                                } else {
                                  await saveNotifier.saveReport(report.id);
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Aduan Terbaru",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => context.push('/all-report'),
            child: Row(
              children: const [
                Text(
                  "Lihat Semua",
                  style: TextStyle(color: Color.fromRGBO(76, 175, 80, 1)),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Color.fromRGBO(76, 175, 80, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          _loadingPlaceholder(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _loadingLine(width: 150),
                const SizedBox(height: 8),
                _loadingLine(width: 100),
                const SizedBox(height: 8),
                _loadingLine(width: 80),
              ],
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

  Widget _loadingLine({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
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
