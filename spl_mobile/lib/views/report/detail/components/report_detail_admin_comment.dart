import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/models/ReportStatusHistory.dart';
import 'package:spl_mobile/models/ReportEvidences.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';

class ReportDetailStatusHistory extends StatelessWidget {
  final List<ReportStatusHistory> statusHistory;
  final List<ReportEvidence> evidences;
  final String status;

  const ReportDetailStatusHistory({
    super.key,
    required this.statusHistory,
    required this.evidences,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("📸 Jumlah evidences: ${evidences.length}");
    for (var ev in evidences) {
      debugPrint("📸 Evidence file: ${ev.file}");
      debugPrint("📸 Full URL: ${ApiConstants.baseUrl}/${ev.file}");
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Judul
          Row(
            children: const [
              Icon(Icons.timeline, color: Colors.green, size: 20),
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

          // 🔹 Riwayat status kosong
          if (statusHistory.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Icon(Icons.hourglass_empty,
                      color: Colors.grey.shade500, size: 40),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length,
              itemBuilder: (context, index) {
                final history = statusHistory[index];
                final bool isLastStatus =
                    index == statusHistory.length - 1;
                final bool showEvidenceSection = (history.newStatus == 'completed' || history.newStatus == 'closed') &&
                    evidences.isNotEmpty &&
                    isLastStatus;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Detail status
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: StatusUtils.getStatusColor(
                                    history.newStatus),
                                size: 14,
                              ),
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
                          Text(
                            _formatCreatedAt(history.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),

                    // 🔹 Tampilkan bukti jika status terakhir = completed / closed
                    if (showEvidenceSection) ...[
                      const SizedBox(height: 16),
                      const Text(
                        "Bukti Penanganan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: evidences.map((evidence) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "${ApiConstants.baseUrl}/${evidence.file}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image,
                                      color: Colors.grey),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatCreatedAt(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(parsedDate);
    } catch (e) {
      return DateFormat('dd MMM yyyy, HH:mm', 'en_US')
          .format(DateTime.parse(dateTime));
    }
  }
}
