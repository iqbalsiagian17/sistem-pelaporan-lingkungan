import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/constants/api.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/user_report_provider.dart';

class RecentReportsSection extends StatelessWidget {
  const RecentReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, reportProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Judul & Lihat Semua
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

            // 📄 List Aduan Terbaru
            if (reportProvider.isLoading)
              const Center(child: CircularProgressIndicator()) // ⏳ Loading indicator
            else if (reportProvider.errorMessage != null)
              Center(child: Text(reportProvider.errorMessage!, style: const TextStyle(color: Colors.red))) // ❌ Tampilkan error
            else if (reportProvider.reports.isEmpty)
              const Center(child: Text("Tidak ada aduan terbaru.")) // 📝 Tidak ada data
            else
              ListView.builder(
                itemCount: reportProvider.reports.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final report = reportProvider.reports[index];

                  // 🔹 Ambil hanya satu gambar pertama dari `attachments`, jika ada
                  String imageUrl = report.attachments.isNotEmpty
                      ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                      : "";

                  return GestureDetector(
                  onTap: () {
                    context.push('/report-detail', extra: report); // ✅ Hanya gunakan `/report-detail`
                  },


                    child: Padding(
                      key: ValueKey(report.id), // ✅ Gunakan key unik berdasarkan ID laporan
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼 Gambar Aduan
                          if (imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/report/report1.jpg",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          if (imageUrl.isNotEmpty) const SizedBox(width: 12), // Beri jarak jika ada gambar

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
                                  "${report.village?.isNotEmpty == true ? report.village : 'Tidak ada lokasi'}, ${report.date}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE9DFFF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    report.status,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9C27B0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔖 Icon Bookmark (Bisa ditambahkan fungsionalitas)
                          IconButton(
                            onPressed: () {
                              // TODO: Tambahkan aksi bookmark
                            },
                            icon: const Icon(Icons.bookmark_border, color: Colors.black54),
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
}
