import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';
import 'package:spl_mobile/views/forum/widget/post_header.dart';
import 'package:spl_mobile/views/forum/widget/post_image_grid.dart';
import 'package:spl_mobile/views/forum/widget/post_actions.dart';
import 'package:spl_mobile/views/forum/detail/forum_detail_view.dart';

class PostCard extends StatelessWidget {
  final ForumPost post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.id;

    final bool isOwner = post.userId == currentUserId;

    return Stack(
      children: [
        InkWell(
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
                PostHeader(post: post),
                const SizedBox(height: 8),
                Text(post.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                if (post.images.isNotEmpty)
                  PostImageGrid(images: post.images.map((img) => img.imageUrl).toList()),
                const SizedBox(height: 10),

                // 🔹 PostActions dan Badge di satu baris jika pemilik
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: PostActions(post: post)),
                    if (post.isPinned && isOwner)
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.push_pin, size: 14, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              'Tersemat',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 🔸 Jika bukan pemilik, tetap tampil di pojok kanan atas
        if (post.isPinned && !isOwner)
          Positioned(
            top: 6,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: const [
                  Icon(Icons.push_pin, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Tersemat',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
