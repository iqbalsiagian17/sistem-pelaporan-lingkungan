import 'package:bb_mobile/features/forum/domain/entities/forum_image_entity.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_action.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_input.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_list.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_detail_header.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_image_grid.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_post_content.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_user_info.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_forum_post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumDetailView extends ConsumerStatefulWidget {
  final ForumPostEntity post;

  const ForumDetailView({super.key, required this.post});

  @override
  ConsumerState<ForumDetailView> createState() => _ForumDetailViewState();
}

class _ForumDetailViewState extends ConsumerState<ForumDetailView> {
  late ForumPostEntity _post;
  late Future<void> _loadPostData;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadPostData = _refreshData();
  }

  Future<void> _refreshData() async {
    final forumNotifier = ref.read(forumProvider.notifier);
    await forumNotifier.fetchPostById(_post.id);
    final updated = ref.read(forumProvider).selectedPost;
    if (mounted && updated != null) {
      setState(() => _post = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileProvider);

    return userState.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const ForumHeader(title: "Detail Postingan"),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ForumUserInfo(post: _post),
                          const SizedBox(height: 12),
                          ForumPostContent(post: _post),
                          const SizedBox(height: 12),
                          if (_post.images.isNotEmpty)
                            ForumImageGrid(
                              images: _post.images
                                  .map((e) => ForumImageEntity(
                                        id: e.id,
                                        postId: _post.id,
                                        imageUrl: e.imageUrl,
                                      ))
                                  .toList(),
                            ),
                          const SizedBox(height: 12),
                          ForumAction(postId: _post.id, commentCount: _post.commentCount),
                          const Divider(thickness: 1),
                          ForumCommentList(post: _post, onCommentDeleted: _refreshData),
                        ],
                      ),
                    ),
                  ),
                ),
                ForumCommentInput(postId: _post.id, onCommentSent: _refreshData),
              ],
            ),
          ),
        );
      },
      loading: () => const ForumDetailSkeleton(),
      error: (_, __) => const Center(child: Text("Gagal memuat pengguna")),
    );
  }
}
