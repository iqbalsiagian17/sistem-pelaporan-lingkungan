import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum/forum_likes_provider.dart';
import 'package:spl_mobile/providers/auth/auth_provider.dart';

class PostActions extends StatelessWidget {
  final ForumPost post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postLikeProvider = Provider.of<PostLikeProvider>(context, listen: false);

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([authProvider.token, authProvider.currentUserId]),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();

        final String token = snapshot.data![0];
        final int userId = snapshot.data![1];

        postLikeProvider.fetchLikeStatus(userId, post.id, token);

        return Consumer<PostLikeProvider>(
          builder: (context, postLikeProvider, child) {
            final bool isLiked = postLikeProvider.isLiked(userId, post.id);
            final int likeCount = postLikeProvider.getLikeCount(post.id);

            return Padding(
              padding: const EdgeInsets.symmetric(), // ✅ Jarak lebih nyaman
              child: Row(
                children: [
                  // **Like Button**
                  GestureDetector(
                    onTap: () async {
                      if (isLiked) {
                        await postLikeProvider.unlikePost(userId, post.id, token);
                      } else {
                        await postLikeProvider.likePost(userId, post.id, token);
                      }
                      await postLikeProvider.fetchLikeCount(post.id, token);
                    },
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLiked ? Colors.red.withOpacity(0.2) : Colors.transparent,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(isLiked),
                              color: isLiked ? Colors.red : Colors.grey.shade700,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$likeCount",
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.grey.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15), // ✅ Jarak antara Like & Komentar

                  // **Komentar**
                  GestureDetector(
                    onTap: () {
                      // 🚀 Bisa diarahkan ke halaman komentar
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${post.comments.length}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
