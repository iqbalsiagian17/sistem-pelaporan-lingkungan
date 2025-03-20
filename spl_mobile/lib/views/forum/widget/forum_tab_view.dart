import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/widget/post_card.dart';

class ForumTabView extends StatelessWidget {
  final TabController tabController;
  final Future<void> Function() onRefresh;

  const ForumTabView({
    super.key,
    required this.tabController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded( // ✅ Pakai Expanded agar langsung ke bawah
      child: Consumer<ForumProvider>(
        builder: (context, forumProvider, child) {
          if (forumProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(), // ✅ Hindari double scroll
            children: [
              _buildPostList(forumProvider.posts), // Tab "Rekomendasi"
              _buildPostList(_getPopularPosts(forumProvider)), // Tab "Populer"
            ],
          );
        },
      ),
    );
  }

  /// **📌 Widget untuk menampilkan daftar postingan**
  Widget _buildPostList(List posts) {
    if (posts.isEmpty) {
      return const Center(child: Text("Belum ada postingan."));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.zero, // ✅ Hilangkan padding ekstra di atas
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }

  /// **📌 Ambil postingan populer berdasarkan jumlah likes**
  List _getPopularPosts(ForumProvider forumProvider) {
    return forumProvider.posts
        .where((post) => post.likes > 0) // 🔥 Hanya postingan dengan likes > 0
        .toList()
      ..sort((a, b) => b.likes.compareTo(a.likes)); // 🔥 Urutkan dari yang terbanyak
  }
}
