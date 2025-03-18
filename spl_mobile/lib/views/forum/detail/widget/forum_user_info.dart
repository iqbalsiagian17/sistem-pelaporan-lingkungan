import 'package:flutter/material.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/models/Forum.dart';

class ForumUserInfo extends StatelessWidget {
  final ForumPost post;

  const ForumUserInfo({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color.fromARGB(255, 34, 143, 90),
          child: Text(
            post.user.username[0].toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.user.username,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "• ${DateUtilsCustom.timeAgo(DateTime.parse(post.createdAt))} • ${post.comments.length} Komentar",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
