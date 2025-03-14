import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/user_report_provider.dart';
import '../../../providers/report_save_provider.dart';

class RecentReportsSection extends StatelessWidget {
  const RecentReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReportProvider, ReportSaveProvider>(
      builder: (context, reportProvider, reportSaveProvider, child) {
        final filteredReports = reportProvider.reports.where((report) =>
            ['verified', 'in_progress', 'completed', 'closed']
                .contains(report.status)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Judul & Tombol "Lihat Semua"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Aduan Terbaru",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      if (context.mounted) {
                        context.go(AppRoutes.allReport);
                      }
                    },
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
            ),
            const SizedBox(height: 8),

            // 🔹 List Aduan Terbaru
              if (reportProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (reportProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Center(
                    child: Text(
                      reportProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (filteredReports.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Center(
                    child: Text(
                      "📭 Tidak ada aduan terbaru.",
                      style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
              ListView.builder(
                itemCount: filteredReports.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final report = filteredReports[index];

                  // ✅ Ambil URL gambar pertama dari attachments jika ada
                  String imageUrl = (report.attachments.isNotEmpty)
                      ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                      : "";

                  // 🔖 **Cek apakah laporan sudah disimpan**
                  bool isSaved = reportSaveProvider.isReportSaved(report.id);

                  return InkWell(
                    onTap: () {
                      context.push('/report-detail', extra: report);
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.green.withOpacity(0.2),
                    child: Padding(
                      key: ValueKey(report.id),
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼 Gambar Aduan dengan CachedNetworkImageProvider
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

                          // 📝 Info Aduan
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
                                    "${report.village?.isNotEmpty == true 
                                        ? report.village 
                                        : report.locationDetails?.isNotEmpty == true 
                                          ? report.locationDetails 
                                          : report.user.username}, ${report.date}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                const SizedBox(height: 4),
                                // 🔹 Status Aduan dengan Animasi Warna
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

                          // 🔖 **Bookmark**
                          IconButton(
                            onPressed: () async {
                              if (isSaved) {
                                await reportSaveProvider.deleteSavedReport(report.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("🔖 Laporan dihapus dari tersimpan"))
                                  );
                                }
                              } else {
                                await reportSaveProvider.saveReport(report.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("✅ Laporan berhasil disimpan"))
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? Colors.green : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  // 🔹 Placeholder saat gambar loading
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

  // 🔹 Gambar default jika gagal dimuat
  Widget _defaultImage() {
    return Image.asset(
      "assets/images/report/report1.jpg",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
}
