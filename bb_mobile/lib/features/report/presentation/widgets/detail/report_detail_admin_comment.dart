import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';
import 'package:bb_mobile/features/report/data/models/report_evidence_model.dart';
import 'package:bb_mobile/features/report/data/models/report_status_history_model.dart';

class ReportDetailStatusHistory extends StatelessWidget {
  final List<ReportStatusHistoryModel> statusHistory;
  final List<ReportEvidenceModel> evidences;
  final String status;

  const ReportDetailStatusHistory({
    super.key,
    required this.statusHistory,
    required this.evidences,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
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

          // 🔹 Konten Riwayat
          if (statusHistory.isEmpty)
            _emptyHistory()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final history = statusHistory[index];
                final isLast = index == statusHistory.length - 1;
                final showEvidence = ['completed', 'closed'].contains(history.newStatus) &&
                    evidences.isNotEmpty &&
                    isLast;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statusItem(history),
                    if (showEvidence) ...[
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
                      _evidenceGrid(),
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

  Widget _emptyHistory() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey.shade500, size: 40),
          const SizedBox(height: 8),
          const Text(
            "Belum ada tanggapan dari admin, mohon bersabar.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _statusItem(ReportStatusHistoryModel history) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                color: StatusUtils.getStatusColor(history.newStatus),
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
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
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
    );
  }

  Widget _evidenceGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: evidences.map((e) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "${ApiConstants.baseUrl}/${e.file}",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatCreatedAt(String dateTime) {
    try {
      final parsed = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(parsed);
    } catch (_) {
      return dateTime;
    }
  }
}
