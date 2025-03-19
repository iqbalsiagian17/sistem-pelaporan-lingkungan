import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum_provider.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_input.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_comment_list.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_detail_header.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_image_grid.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_post_content.dart';
import 'package:spl_mobile/views/forum/detail/widget/forum_user_info.dart';

class ForumDetailView extends StatefulWidget {
  final ForumPost post;

  const ForumDetailView({super.key, required this.post});

  @override
  _ForumDetailViewState createState() => _ForumDetailViewState();
}

class _ForumDetailViewState extends State<ForumDetailView> {
  late ForumPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;

    Future.microtask(() {
      if (mounted) {
        _refreshComments(); // 🔄 Ambil data terbaru saat halaman dibuka
      }
    });
  }

  /// **Fungsi untuk refresh komentar setelah komentar baru dikirim**
  Future<void> _refreshComments() async {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    await forumProvider.fetchPostById(_post.id); // 🔄 Ambil data terbaru
    
    if (mounted) {
      setState(() {
        _post = forumProvider.selectedPost ?? _post; // Gunakan data terbaru
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: ForumHeader(title: "Detail Postingan"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ForumUserInfo(post: _post),
                    const SizedBox(height: 12),
                    ForumPostContent(post: _post),
                    if (_post.images.isNotEmpty) ForumImageGrid(images: _post.images),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIconWithText(Icons.chat_bubble_outline, "${_post.comments.length}"),
                          _buildIconWithText(Icons.favorite_border, "230"),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),
                  ForumCommentList(
                    post: _post,
                    onCommentDeleted: _refreshComments, // ✅ Refresh komentar setelah dihapus
                  ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: ForumCommentInput(
                postId: _post.id,
                onCommentSent: _refreshComments, // ✅ Perbarui komentar setelah dikirim
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 **Widget untuk Menampilkan Ikon & Jumlahnya**
  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }
}
