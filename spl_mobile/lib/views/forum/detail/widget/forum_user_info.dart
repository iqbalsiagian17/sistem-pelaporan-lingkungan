import 'package:flutter/material.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/views/forum/widget/post_popup_menu.dart';

class ForumUserInfo extends StatelessWidget {
  final ForumPost post;

  const ForumUserInfo({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // **Avatar Profil**
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color.fromARGB(255, 34, 143, 90),
          child: Text(
            post.user.username[0].toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),

        // **Informasi User**
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Nama Lengkap**
              Text(
                post.user.username,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              // **Username Twitter-style (@username)**
              Text(
                "@${post.user.username.toLowerCase()}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),

        // **Titik Tiga untuk Opsi Postingan**
        PostPopupMenu(post: post),
      ],
    );
  }
}
