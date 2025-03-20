import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/widget/post_card.dart';

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
    
    // ✅ Tambahkan listener agar refresh otomatis saat tab berubah
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
          if (forumProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: widget.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPostList(forumProvider.posts),
              _buildPostList(_getPopularPosts(forumProvider)),
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
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }

  List _getPopularPosts(ForumProvider forumProvider) {
    return forumProvider.posts
        .where((post) => post.likes > 0)
        .toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
  }
}
