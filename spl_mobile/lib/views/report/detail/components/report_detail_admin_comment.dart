import 'package:flutter/material.dart';

class ReportDetailAdminComment extends StatelessWidget {
  final List<Map<String, String>> adminComments; // ✅ Daftar komentar

  const ReportDetailAdminComment({super.key, required this.adminComments});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ Full width agar sejajar dengan elemen lain
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // ✅ Border radius lebih kecil untuk tampilan modern
        border: Border.all(color: Colors.grey.shade300, width: 1), // ✅ Border tipis tanpa shadow
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // ✅ Padding agar tidak terlalu padat
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Judul "Proses Aduan"
            Row(
              children: const [
                Icon(Icons.history, color: Colors.green, size: 20), // ✅ Tambahkan ikon
                SizedBox(width: 8),
                Text(
                  "Proses Aduan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Tampilkan daftar komentar dengan pemisah
            ListView.separated(
              shrinkWrap: true, // ✅ Agar tidak menyebabkan overflow
              physics: const NeverScrollableScrollPhysics(), // ✅ Gunakan scroll utama
              itemCount: adminComments.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300), // ✅ Pemisah antar komentar
              itemBuilder: (context, index) {
                final comment = adminComments[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Status dengan ikon
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.blueGrey, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            comment['status'] ?? "Status tidak diketahui",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // 🔹 Isi Komentar Admin
                      Text(
                        comment['comment'] ?? "Tidak ada komentar",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 4),

                      // 🔹 Tanggal Komentar
                      Text(
                        comment['timestamp'] ?? "Waktu tidak diketahui",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
