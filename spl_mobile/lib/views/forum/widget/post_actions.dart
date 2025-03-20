import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/user_post_likes_provider.dart';
import 'package:spl_mobile/providers/auth_provider.dart';

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

        // 🔥 Fetch status like setiap kali post ditampilkan (agar status like langsung muncul)
        postLikeProvider.fetchLikeStatus(userId, post.id, token);

        return Consumer<PostLikeProvider>(
          builder: (context, postLikeProvider, child) {
            final bool isLiked = postLikeProvider.isLiked(userId, post.id);
            final int likeCount = postLikeProvider.getLikeCount(post.id);

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildIconWithText(Icons.mode_comment_outlined, "${post.comments.length}"),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    if (isLiked) {
                      await postLikeProvider.unlikePost(userId, post.id, token);
                    } else {
                      await postLikeProvider.likePost(userId, post.id, token);
                    }
                    // 🔥 **Ambil jumlah like terbaru setelah like/unlike**
                    await postLikeProvider.fetchLikeCount(post.id, token);
                  },
                  child: _buildIconWithText(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    "$likeCount",
                    color: isLiked ? Colors.red : Colors.grey.shade700,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 📌 **Membuat ikon dengan teks**
  Widget _buildIconWithText(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade700),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color ?? Colors.grey.shade700, fontSize: 14)),
      ],
    );
  }
}
