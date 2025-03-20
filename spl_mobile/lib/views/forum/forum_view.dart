import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/providers/user_post_likes_provider.dart';
import 'package:spl_mobile/views/forum/widget/forum_tab_bar.dart';
import 'package:spl_mobile/views/forum/widget/forum_tab_view.dart';
import 'package:spl_mobile/views/forum/widget/forum_header.dart';
import 'package:spl_mobile/views/forum/widget/create_post_modal.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  _ForumViewState createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _refreshForumPosts());
  }

  /// 🔄 **Refresh daftar postingan**
  Future<void> _refreshForumPosts() async {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    final postLikeProvider = Provider.of<PostLikeProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await forumProvider.fetchAllPosts();

    final String? token = await authProvider.token;
    if (token != null) {
      for (var post in forumProvider.posts) {
        await postLikeProvider.fetchLikeCount(post.id, token);
      }
    }
  }

  /// ✍️ **Tampilkan Modal untuk Membuat Postingan**
  Future<void> _showCreatePostModal(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => const CreatePostModal(),
    );

    if (result == true) {
      await _refreshForumPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      /// ✅ **Header Full (ForumHeader + ForumTabBar)**
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            const ForumHeader(title: "Forum Diskusi"), // ✅ Header utama
            ForumTabBar(tabController: _tabController), // ✅ TabBar dengan controller
          ],
        ),
      ),

      /// ✅ **Body dengan TabBarView (menggunakan ForumTabView)**
      body: ForumTabView(
        tabController: _tabController,
        onRefresh: _refreshForumPosts,
      ),

      /// ✅ **Floating Action Button untuk Tambah Postingan**
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostModal(context),
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
