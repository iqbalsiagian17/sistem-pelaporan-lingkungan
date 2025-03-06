import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/core/constants/api.dart'; // ✅ Import ApiConstants
import './report_list_empety.dart';

class ReportSaveDataState extends StatelessWidget {
  final List<Report> reports;
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.reports, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? ReportListAllEmptyState(onRetry: onRetry)
        : ListView.builder(
            itemCount: reports.length,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (context, index) {
              final report = reports[index];

              // ✅ Ambil base URL dari ApiConstants
              String imageUrl = (report.attachments.isNotEmpty)
                  ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                  : "assets/images/report/report1.jpg"; // Gambar default jika tidak ada attachment

              debugPrint("🔹 Image URL: $imageUrl");

              return GestureDetector(
                onTap: () {
                  context.push(AppRoutes.reportDetail, extra: report);
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 12.0 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼️ Gambar laporan
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imageUrl.startsWith("http")
                            ? Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint("❌ Error loading image: $error");
                                  return Image.asset(
                                    "assets/images/report/report1.jpg",
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12),

                      // 📝 Informasi laporan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title.isNotEmpty ? report.title : "Judul tidak tersedia", // ✅ Hindari null
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
                          ],
                        ),
                      ),

                      // 🔖 Icon Bookmark
                      IconButton(
                        onPressed: () {
                          // TODO: Implementasikan fitur bookmark
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
}
