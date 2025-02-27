import 'package:flutter/material.dart';

class RecentReportsSection extends StatelessWidget {
  const RecentReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {
        "image": "assets/images/report/report1.jpg",
        "title": "Ada kebocoran PDAM di Perempatan Jln gajah mada arah ke kh.wahid hasyim...",
        "location": "Balige",
        "time": "11 jam yang lalu",
        "status": "Disposisi",
      },
      {
        "image": "assets/images/report/report2.jpg",
        "title": "Aplikasi Tidak bermanfaat. Saya lapor pengaduan disini Sudah 2 t...",
        "location": "Balige",
        "time": "12 jam yang lalu",
        "status": "Disposisi",
      },
      {
        "image": "assets/images/report/report3.jpg",
        "title": "Mohon bertanya apakah iuran tali asih purna tugas guru i...",
        "location": "Balige",
        "time": "13 jam yang lalu",
        "status": "Disposisi",
      },
      {
        "image": "assets/images/report/report4.jpg",
        "title": "Mohon dibenahi pak, Jembatan yg terletak diperbatasan Desa Tegalrejo...",
        "location": "Balige",
        "time": "13 jam yang lalu",
        "status": "Disposisi",
      },
    ];

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
                  // TODO: Navigasi ke halaman "Lihat Semua"
                },
                child: Row(
                  children: const [
                    Text("Lihat Semua", style: TextStyle(color: Color.fromRGBO(76, 175, 80, 1))),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Color.fromRGBO(76, 175, 80, 1)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 📄 List Aduan Terbaru
        ListView.builder(
          itemCount: reports.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            final report = reports[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Gambar Aduan
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      report["image"]!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 📝 Info Aduan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report["title"]!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${report["location"]}, ${report["time"]}",
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
                            report["status"]!,
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

                  // 🔖 Icon Bookmark
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
        ),
      ],
    );
  }
}
