import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_report_list.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/report/report_provider.dart';
import '../../../providers/report/report_save_provider.dart';

class RecentReportsSection extends StatelessWidget {
  const RecentReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReportProvider, ReportSaveProvider>(
      builder: (context, reportProvider, reportSaveProvider, child) {
        final filteredReports = reportProvider.reports
            .where((report) => ['verified', 'in_progress', 'completed', 'closed'].contains(report.status))
            .take(5) // 👈 Ambil hanya 5 data
            .toList();


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
                ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    return const SkeletonReportList();
                  },
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
              Padding(
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go(AppRoutes.createReport); // 💡 arahkan ke halaman buat laporan
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Buat Aduan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
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
                                  report.village?.isNotEmpty == true
                                      ? "${report.village}, ${report.date}"
                                      : "${report.date}",
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
