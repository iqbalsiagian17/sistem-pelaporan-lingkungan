import 'package:flutter/material.dart';

class ReportDetailUserReview extends StatelessWidget {
  final String? review;
  final int? rating;

  const ReportDetailUserReview({
    super.key,
    this.review,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    if (rating == null && (review == null || review!.isEmpty)) {
      return const SizedBox(); // Tidak tampil jika belum ada review
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Penilaian Terhadap Laporan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, size: 20),
                color: Colors.grey[600],
                tooltip: "Tentang penilaian ini",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    backgroundColor: Colors.white,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Informasi Penilaian",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Ini adalah penilaian yang dilakukan oleh pelapor terhadap laporan yang diberikan kepada Dinas Lingkungan Hidup.",
                            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (rating != null)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating! ? Icons.star : Icons.star_border,
                  color: Colors.orangeAccent,
                  size: 20,
                );
              }),
            ),
          if (review != null && review!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}
