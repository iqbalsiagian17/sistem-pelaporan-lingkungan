import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/widget/post_card.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_forum_post.dart';

class ForumTabView extends StatefulWidget {
  final TabController tabController;
  final Future<void> Function() onRefresh;

  const ForumTabView({
    super.key,
    required this.tabController,
    required this.onRefresh,
  });

  @override
  _ForumTabViewState createState() => _ForumTabViewState();
}

class _ForumTabViewState extends State<ForumTabView> {
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
    return Expanded(
      child: Consumer<ForumProvider>(
        builder: (context, forumProvider, child) {
          return TabBarView(
            controller: widget.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              forumProvider.isLoading
                  ? _buildSkeletonList()
                  : _buildPostList(forumProvider.posts),
              forumProvider.isLoading
                  ? _buildSkeletonList()
                  : _buildPostList(_getPopularPosts(forumProvider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPostList(List posts) {
    if (posts.isEmpty) {
      return const Center(child: Text("Belum ada postingan."));
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
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

  List _getPopularPosts(ForumProvider forumProvider) {
    return forumProvider.posts
        .where((post) => post.likes > 0)
        .toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
  }
}
