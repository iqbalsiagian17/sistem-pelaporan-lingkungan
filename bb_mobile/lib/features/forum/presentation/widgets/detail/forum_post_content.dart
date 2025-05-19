import 'package:bb_mobile/core/utils/date_utils.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:flutter/material.dart';

class ForumPostContent extends StatelessWidget {
  final ForumPostEntity post;

  const ForumPostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final createdAtLocal = DateTime.parse(post.createdAt).toLocal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🟢 Konten Postingan
        Text(
          post.content,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // 🕒 Waktu & Tanggal Posting
        Text(
          "${DateUtilsCustom.formatTime(createdAtLocal)} · "
          "${DateUtilsCustom.formatDate(createdAtLocal)}",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
