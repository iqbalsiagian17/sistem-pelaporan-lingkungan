import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/create_post_modal.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_header.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_tab_bar.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumListView extends ConsumerStatefulWidget {
  const ForumListView({super.key});

  @override
  ConsumerState<ForumListView> createState() => _ForumListViewState();
}

class _ForumListViewState extends ConsumerState<ForumListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _refreshForumPosts());
  }

  /// 🔄 Refresh semua postingan
  Future<void> _refreshForumPosts() async {
    await ref.read(forumProvider.notifier).fetchAllPosts();
  }

  /// ➕ Tampilkan modal tambah postingan
  Future<void> _showCreatePostModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CreatePostModal(),
    );

    if (result == true) {
      await _refreshForumPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            const ForumHeader(title: "Forum Diskusi"),
            ForumTabBar(tabController: _tabController),
          ],
        ),
      ),

      body: ForumTabView(
        tabController: _tabController,
        onRefresh: _refreshForumPosts,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostModal,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
