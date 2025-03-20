import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/views/forum/widget/post_header.dart';
import 'package:spl_mobile/views/forum/widget/post_image_grid.dart';
import 'package:spl_mobile/views/forum/widget/post_actions.dart';
import 'package:spl_mobile/views/forum/detail/forum_detail_view.dart';

class PostCard extends StatelessWidget {
  final ForumPost post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumDetailView(post: post)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post),  // 🔹 Header
            const SizedBox(height: 8),
            Text(post.content, style: const TextStyle(fontSize: 16)), // 🔹 Konten teks
            const SizedBox(height: 12),
            if (post.images.isNotEmpty) 
              PostImageGrid(images: post.images.map((img) => img.imageUrl).toList()), // 🔹 Gambar
            const SizedBox(height: 10),
            PostActions(post: post), // 🔹 Tombol Like & Comment
          ],
        ),
      ),
    );
  }
}
