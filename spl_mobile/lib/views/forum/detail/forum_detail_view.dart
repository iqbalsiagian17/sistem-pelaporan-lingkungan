import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/providers/user_post_likes_provider.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_input.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_list.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_detail_header.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_image_grid.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_post_content.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_user_info.dart';
import 'package:spl_mobile/providers/auth_provider.dart';

class ForumDetailView extends StatefulWidget {
  final ForumPost post;

  const ForumDetailView({super.key, required this.post});

  @override
  _ForumDetailViewState createState() => _ForumDetailViewState();
}

class _ForumDetailViewState extends State<ForumDetailView> {
  late ForumPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;

    Future.microtask(() {
      if (mounted) {
        _refreshData();
      }
    });
  }

  /// **🔄 Fungsi untuk refresh komentar dan like setelah interaksi**
  Future<void> _refreshData() async {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final String? token = await authProvider.token;
    final int? userId = await authProvider.currentUserId;

    if (token != null && userId != null) {
      try {
        await Future.wait([
          forumProvider.fetchPostById(_post.id),
          Provider.of<PostLikeProvider>(context, listen: false).fetchLikeStatus(userId, _post.id, token),
          Provider.of<PostLikeProvider>(context, listen: false).fetchLikeCount(_post.id, token),
        ]);

        if (mounted) {
          setState(() {
            _post = forumProvider.selectedPost ?? _post;
          });
        }

      } catch (e) {
        print("❌ [ForumDetailView] Error saat memuat data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<String?>(
      future: authProvider.token,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        final String token = snapshot.data!;

        return FutureBuilder<int?>(
          future: authProvider.currentUserId,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const SizedBox();
            }

            final int userId = userSnapshot.data!;

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: ForumHeader(title: "Detail Postingan"),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ForumUserInfo(post: _post),
                            const SizedBox(height: 12),
                            ForumPostContent(post: _post),
                            if (_post.images.isNotEmpty) ForumImageGrid(images: _post.images),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildIconWithText(Icons.chat_bubble_outline, "${_post.comments.length}"),

                                  // 🔹 **Tombol Like dengan Provider**
                                  Consumer<PostLikeProvider>(
                                    builder: (context, likeProvider, child) {
                                      final bool isLiked = likeProvider.isLiked(userId, _post.id);
                                      final int likeCount = likeProvider.getLikeCount(_post.id);

                                      return InkWell(
                                        onTap: () async {
                                          try {
                                            if (isLiked) {
                                              await likeProvider.unlikePost(userId, _post.id, token);
                                            } else {
                                              await likeProvider.likePost(userId, _post.id, token);
                                            }
                                          } catch (e) {
                                            print("❌ [Like/Unlike] Error: $e");
                                          }
                                        },
                                        child: _buildLikeIcon(
                                          isLiked ? Icons.favorite : Icons.favorite_border,
                                          "$likeCount",
                                          isLiked ? Colors.red : Colors.grey.shade700,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1),
                            ForumCommentList(
                              post: _post,
                              onCommentDeleted: _refreshData,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: ForumCommentInput(
                        postId: _post.id,
                        onCommentSent: _refreshData,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 🔥 **Widget untuk Menampilkan Ikon & Jumlahnya**
  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }

  /// ❤️ **Widget untuk Like & Unlike**
  Widget _buildLikeIcon(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
