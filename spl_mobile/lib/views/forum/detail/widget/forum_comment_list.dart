import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/forum_provider.dart';

class ForumCommentList extends StatefulWidget {
  final ForumPost post;

  const ForumCommentList({super.key, required this.post});

  @override
  _ForumCommentListState createState() => _ForumCommentListState();
}

class _ForumCommentListState extends State<ForumCommentList> {
  int? _replyingToCommentId;
  final TextEditingController _replyController = TextEditingController();

  /// **Fungsi untuk mengirim balasan komentar**
  Future<void> _sendReply(int commentId, String replyToUsername) async {
    if (_replyController.text.trim().isEmpty) return;

    final forumProvider = Provider.of<ForumProvider>(context, listen: false);

    bool success = await forumProvider.addComment(
      postId: widget.post.id,
      content: "@$replyToUsername ${_replyController.text.trim()}",
    );

    if (success) {
      setState(() {
        _replyingToCommentId = null;
        _replyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.post.comments.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.post.comments.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.5, height: 16, color: Colors.grey),
            itemBuilder: (context, index) {
              final comment = widget.post.comments[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 **Avatar User**
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _generateColorFromUsername(comment.user.username),
                          child: Text(
                            comment.user.username[0].toUpperCase(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // 🔹 **Komentar**
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 **Username & Waktu**
                              Row(
                                children: [
                                  Text(
                                    comment.user.username,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "• ${DateUtilsCustom.timeAgo(DateTime.parse(comment.createdAt))}",
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  ),
                                ],
                              ),

                              // 🔹 **Isi Komentar**
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  comment.content,
                                  style: const TextStyle(fontSize: 14, height: 1.4),
                                ),
                              ),

                              // 🔹 **Tombol Balas Komentar**
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 **Form Input Balasan Komentar (Muncul Jika Ditekan)**
                  if (_replyingToCommentId == comment.id)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _replyController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                ],
              );
            },
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Belum ada komentar.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
  }

  /// 🔹 **Fungsi untuk menghasilkan warna avatar berdasarkan username**
  Color _generateColorFromUsername(String username) {
    final List<Color> colors = [
      Colors.blueAccent, Colors.green, Colors.deepOrange, Colors.purpleAccent, Colors.teal, Colors.redAccent
    ];
    return colors[username.length % colors.length];
  }
}
