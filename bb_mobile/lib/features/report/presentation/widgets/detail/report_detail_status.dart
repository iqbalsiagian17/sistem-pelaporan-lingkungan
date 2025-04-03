import 'package:flutter/material.dart';
import 'package:bb_mobile/core/utils/status_utils.dart';

class ReportDetailStatus extends StatelessWidget {
  final int reportId;
  final String? status;
  final int likes;

  const ReportDetailStatus({
    super.key,
    required this.reportId,
    required this.likes,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🔹 Status Aduan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: StatusUtils.getStatusColor(status),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            StatusUtils.getTranslatedStatus(status),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Row(
          children: [
            // ❤️ Like (static UI)
            Row(
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  "$likes",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // 🔖 Bookmark (static UI)
            const Icon(
              Icons.bookmark_border,
              color: Colors.black54,
            ),
          ],
        ),
      ],
    );
  }
}
