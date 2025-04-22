import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_card.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_forum_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumTabView extends ConsumerStatefulWidget {
  final TabController tabController;
  final Future<void> Function() onRefresh;

  const ForumTabView({
    super.key,
    required this.tabController,
    required this.onRefresh,
  });

  @override
  ConsumerState<ForumTabView> createState() => _ForumTabViewState();
}

class _ForumTabViewState extends ConsumerState<ForumTabView> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        widget.onRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forumProvider);

    return TabBarView(
      controller: widget.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        state.isLoading
            ? _buildSkeletonList()
            : _buildPostList(state.posts),
        state.isLoading
            ? _buildSkeletonList()
            : _buildPostList(_getPopularPosts(state.posts)),
      ],
    );
  }

  Widget _buildPostList(List<ForumPostEntity> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text("Belum ada postingan."));
    }
    print("📦 Total post ditemukan: ${posts.length}");

    final pinned = posts.where((p) => p.isPinned).toList();
    final notPinned = posts.where((p) => !p.isPinned).toList();
    final sorted = [...pinned, ...notPinned];

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: sorted.length,
        itemBuilder: (context, index) => PostCard(post: sorted[index]),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) => const SkeletonForumPost(),
    );
  }

  List<ForumPostEntity> _getPopularPosts(List<ForumPostEntity> posts) {
    return posts
        .where((post) => post.likeCount > 0)
        .toList()
      ..sort((a, b) => b.likeCount.compareTo(a.likeCount));
  }
}
