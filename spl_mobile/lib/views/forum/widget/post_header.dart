import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/views/forum/widget/post_popup_menu.dart';

class PostHeader extends StatelessWidget {
  final ForumPost post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: Text(
            post.user.username[0].toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("• ${DateUtilsCustom.timeAgo(DateTime.parse(post.createdAt))}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
        
        // 🔹 **Gunakan PostPopupMenu dengan parameter yang benar**
        PostPopupMenu(post: post),
      ],
    );
  }
}
