import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/create_post_modal.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/edit_post_modal.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_header.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_tab_bar.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/forum_tab_view.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForumListView extends ConsumerStatefulWidget {
  const ForumListView({super.key});

  @override
  ConsumerState<ForumListView> createState() => _ForumListViewState();
}

class _ForumListViewState extends ConsumerState<ForumListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasOpenedModal = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _refreshForumPosts());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final query = GoRouterState.of(context).uri.queryParameters;
    if (!_hasOpenedModal && query['openModal'] == 'create') {
      _hasOpenedModal = true;
      Future.microtask(() => _showCreatePostModal());
    }
  }

  Future<void> _refreshForumPosts() async {
    await ref.read(forumProvider.notifier).fetchAllPosts();
  }

  Future<void> _showCreatePostModal() async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    final result = await showModalBottomSheet<bool>(
      context: rootContext,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const CreatePostModal(),
    );

    if (result == true) {
      await _refreshForumPosts();

      if (mounted) {
        // ✅ Gunakan SnackbarHelper dan context dari ForumListView (bukan rootContext!)
        SnackbarHelper.showSnackbar(
          context,
          'Postingan berhasil dibuat!',
          isError: false,
        );
      }
    }
  }

  Future<void> _showEditPostModal(ForumPostEntity post) async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    final result = await showModalBottomSheet<bool>(
      context: rootContext,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => EditPostModal(post: post),
    );

    if (result == true) {
      await _refreshForumPosts();

      if (mounted) {
        SnackbarHelper.showSnackbar(
          context,
          'Postingan berhasil diperbarui!',
        );
      }
    }
  }

  Future<void> _deletePost(ForumPostEntity post) async {
  final success = await ref.read(forumProvider.notifier).deletePost(post.id);
  await _refreshForumPosts();
  SnackbarHelper.showSnackbar(
    context,
    success ? "Postingan berhasil dihapus" : "Gagal menghapus postingan",
    isError: !success,
  );
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
      body: Column(
        children: [
          Expanded(
            child: ForumTabView(
              tabController: _tabController,
              onRefresh: _refreshForumPosts,
              onEditPost: _showEditPostModal,
              onDeletePost: _deletePost,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostModal,
        backgroundColor: const Color(0xFF66BB6A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
