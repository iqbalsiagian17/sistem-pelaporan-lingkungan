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

class ForumDetailView extends StatelessWidget {
  final ForumPost post;

  const ForumDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Hindari overflow saat keyboard muncul
      backgroundColor: Colors.white,
      appBar: ForumHeader(title: "Detail Postingan"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // ✅ Pastikan tetap bisa di-scroll
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 **Informasi User**
                    ForumUserInfo(post: post),
                    const SizedBox(height: 12),

                    // 🔹 **Konten Postingan**
                    ForumPostContent(post: post),
                    if (post.images.isNotEmpty) ForumImageGrid(images: post.images),

                    // 🔹 **Aksi Like & Komentar**
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 🔹 **Jumlah Komentar**
                          _buildIconWithText(Icons.chat_bubble_outline, "${post.comments.length}"),

                          // 🔹 **Jumlah Like (Dummy)**
                          _buildIconWithText(Icons.favorite_border, "230"), // 🛑 Gantilah dengan jumlah like asli
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),

                    // 🔹 **List Komentar**
                    ForumCommentList(post: post), // ✅ Pastikan bisa scroll komentar
                  ],
                ),
              ),
            ),

            // 🔹 **Input Komentar dengan SafeArea**
            SafeArea(
              child: ForumCommentInput(postId: post.id), // ✅ Pastikan input tetap terlihat
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
