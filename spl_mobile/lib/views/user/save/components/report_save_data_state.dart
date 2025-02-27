import 'package:flutter/material.dart';
import './report_save_empty_state.dart'; // ✅ Import jika data kosong

class ReportSaveDataState extends StatelessWidget {
  final List<Map<String, String>> savedReports;
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.savedReports, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return savedReports.isEmpty
        ? ReportSaveEmptyState(onRetry: onRetry) // ✅ Jika kosong, tampilkan pesan
        : ListView.builder(
            itemCount: savedReports.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0), // ✅ Jarak dari atas
            itemBuilder: (context, index) {
              final report = savedReports[index];

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

                    // 🔖 Ikon Bookmark Aktif
                    IconButton(
                      onPressed: () {
                        // TODO: Tambahkan aksi untuk menghapus dari laporan tersimpan
                      },
                      icon: const Icon(Icons.bookmark, color: Colors.green), // ✅ Bookmark aktif (tersimpan)
                    ),
                  ],
                ),
              );
            },
          );
  }
}
