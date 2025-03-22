import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_input.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_list.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_detail_header.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_image_grid.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_post_content.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_user_info.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_action.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_forum_post_detail.dart';

class ForumDetailView extends StatefulWidget {
  final ForumPost post;

  const ForumDetailView({super.key, required this.post});

  @override
  _ForumDetailViewState createState() => _ForumDetailViewState();
}

class _ForumDetailViewState extends State<ForumDetailView> {
  late Future<void> _loadPostData;
  late ForumPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadPostData = _refreshData();
  }

  /// **🔄 Refresh Data Postingan**
  Future<void> _refreshData() async {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final String? token = await authProvider.token;
    final int? userId = await authProvider.currentUserId;

    if (token == null || userId == null || token.isEmpty || userId <= 0) {
      debugPrint("❌ Token atau User ID tidak valid");
      return;
    }

    try {
      ForumPost? updatedPost = await forumProvider.fetchPostById(_post.id);
      if (updatedPost != null && mounted) {
        setState(() {
          _post = updatedPost;
        });
      }
    } catch (e) {
      debugPrint("❌ [ForumDetailView] Error saat memuat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Provider.of<AuthProvider>(context, listen: false).token,
      builder: (context, tokenSnapshot) {
        if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
          return _loadingScreen();
        }

        return FutureBuilder<int?>(
          future: Provider.of<AuthProvider>(context, listen: false).currentUserId,
          builder: (context, userIdSnapshot) {
            if (!userIdSnapshot.hasData || userIdSnapshot.data == null) {
              return _loadingScreen();
            }

            final String token = tokenSnapshot.data ?? "";
            final int userId = userIdSnapshot.data ?? 0;

            return Scaffold(
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
                            const SizedBox(height: 12),
                            if (_post.images.isNotEmpty) ForumImageGrid(images: _post.images),
                            const SizedBox(height: 12),

                            // **Bagian Like & Komentar dalam ForumAction**
                            ForumAction(
                              postId: _post.id,
                              token: token,
                              userId: userId,
                              commentCount: _post.comments.length,
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

  /// **🔥 Loading Screen dengan Background Putih**
  Widget _loadingScreen() {
  return const ForumDetailSkeleton();
  }
}
