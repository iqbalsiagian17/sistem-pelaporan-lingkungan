import 'package:flutter/material.dart';
import 'report_empty_state.dart'; // ✅ Import ReportEmptyState

class ReportDataState extends StatelessWidget {
  final List<Map<String, String>> reports;
  final VoidCallback onRetry;

  const ReportDataState({super.key, required this.reports, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? ReportEmptyState(onRetry: onRetry) // ✅ Jika kosong, tampilkan EmptyState
        : ListView.builder(
            itemCount: reports.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0), // ✅ Tambah padding atas
            itemBuilder: (context, index) {
              final report = reports[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 12.0 : 0), // ✅ Jarak tambahan untuk item pertama
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Gambar Laporan
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        report["image"] ?? "assets/images/default.jpg", // ✅ Gunakan gambar default jika null
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 📝 Info Laporan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report["title"] ?? "Judul tidak tersedia", // ✅ Gunakan default jika null
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${report["location"] ?? "Lokasi tidak tersedia"}, ${report["time"] ?? "Waktu tidak diketahui"}",
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
                              report["status"] ?? "Status tidak diketahui",
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

                    // 🔖 Icon Bookmark (Tetap Kosong)
                    IconButton(
                      onPressed: () {
                        // TODO: Tambahkan aksi bookmark
                      },
                      icon: const Icon(Icons.bookmark_border, color: Colors.black54),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
