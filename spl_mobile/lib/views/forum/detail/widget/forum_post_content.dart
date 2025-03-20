import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';

class ForumPostContent extends StatelessWidget {
  final ForumPost post;

  const ForumPostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // **Konten Postingan**
        Text(
          post.content,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // **Waktu, Tanggal, dan Tayangan**
        Text(
          "${DateUtilsCustom.formatTime(DateTime.parse(post.createdAt))} · "
          "${DateUtilsCustom.formatDate(DateTime.parse(post.createdAt))}",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
