import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/widget/post_card.dart';
import 'package:spl_mobile/views/forum/widget/forum_header.dart';
import 'package:spl_mobile/views/forum/widget/create_post_modal.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  _ForumViewState createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      if (mounted) {
        Provider.of<ForumProvider>(context, listen: false).fetchAllPosts();
      }
    });
  }

  void showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => const CreatePostModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ForumHeader(title: "Forum Diskusi"),
      body: Consumer<ForumProvider>(
        builder: (context, forumProvider, child) {
          if (forumProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (forumProvider.posts.isEmpty) {
            return const Center(child: Text("Belum ada postingan."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await forumProvider.fetchAllPosts();
            },
            child: ListView.builder(
              itemCount: forumProvider.posts.length,
              itemBuilder: (context, index) {
                final post = forumProvider.posts[index];
                return PostCard(post: post);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreatePostModal(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
