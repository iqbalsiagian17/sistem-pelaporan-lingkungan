import 'package:flutter/material.dart';
import 'package:spl_mobile/models/ReportStatusHistory.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';

class ReportDetailStatusHistory extends StatelessWidget {
  final List<ReportStatusHistory> statusHistory; // ✅ Daftar riwayat status

  const ReportDetailStatusHistory({super.key, required this.statusHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ Full width agar sejajar dengan elemen lain
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // ✅ Border radius lebih kecil untuk tampilan modern
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // ✅ Padding agar tidak terlalu padat
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Judul "Riwayat Perubahan Status"
            Row(
              children: const [
                Icon(Icons.timeline, color: Colors.green, size: 20), // ✅ Tambahkan ikon
                SizedBox(width: 8),
                Text(
                  "Riwayat Perubahan Status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Jika statusHistory kosong, tampilkan pesan
            if (statusHistory.isEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty, color: Colors.grey.shade500, size: 40), // ⏳ Ikon menunggu
                    const SizedBox(height: 8),
                    const Text(
                      "Belum ada tanggapan dari admin, mohon bersabar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true, // ✅ Agar tidak menyebabkan overflow
                physics: const NeverScrollableScrollPhysics(), // ✅ Gunakan scroll utama
                itemCount: statusHistory.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300), // ✅ Pemisah antar status
                itemBuilder: (context, index) {
                  final history = statusHistory[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Status dengan ikon perubahan & warna
                        Row(
                          children: [
                            Icon(Icons.circle, color: StatusUtils.getStatusColor(history.newStatus), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              "${StatusUtils.getTranslatedStatus(history.previousStatus)} → ${StatusUtils.getTranslatedStatus(history.newStatus)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // 🔹 Isi Pesan Perubahan Status
                        Text(
                          history.message,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 4),

                        // 🔹 Admin yang Mengubah Status (Opsional)
                        if (history.admin.username.isNotEmpty)
                          Text(
                            "Diperbarui oleh: ${history.admin.username}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),

                        const SizedBox(height: 4),

                        // 🔹 Tanggal Perubahan Status
                        Text(
                          history.createdAt,
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
