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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(forumProvider.notifier).fetchPostById(widget.post.id);
    });
  }

  Future<void> _refreshData() async {
    await ref.read(forumProvider.notifier).fetchPostById(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileProvider);
    final forumState = ref.watch(forumProvider);

    final ForumPostEntity post = forumState.selectedPost ?? widget.post;

    return userState.when(
      data: (_) {
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
                          ForumUserInfo(post: post),
                          const SizedBox(height: 12),
                          ForumPostContent(post: post),
                          const SizedBox(height: 12),
                          if (post.images.isNotEmpty)
                            ForumImageGrid(images: post.images),
                          const SizedBox(height: 12),
                          ForumAction(postId: post.id, commentCount: post.commentCount),
                          const Divider(thickness: 1),
                          ForumCommentList(post: post, onCommentDeleted: _refreshData),
                        ],
                      ),
                    ),
                  ),
                ),
                ForumCommentInput(postId: post.id, onCommentSent: _refreshData),
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
