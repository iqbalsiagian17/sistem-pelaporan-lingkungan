import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/core/utils/date_utils.dart';
import 'package:spl_mobile/models/Forum.dart';
import 'package:spl_mobile/providers/auth_provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';

class ForumCommentList extends StatefulWidget {
  final ForumPost post;
  final Function()? onCommentDeleted; // ✅ Callback untuk refresh komentar setelah dihapus

  const ForumCommentList({super.key, required this.post, required this.onCommentDeleted});

  @override
  _ForumCommentListState createState() => _ForumCommentListState();
}

class _ForumCommentListState extends State<ForumCommentList> {
  int? _replyingToCommentId;
  final TextEditingController _replyController = TextEditingController();

  /// **🔹 Fungsi untuk mengirim balasan komentar**
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

  /// **🔹 Fungsi untuk menghapus komentar**
  Future<void> _deleteComment(int commentId) async {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);

    bool success = await forumProvider.removeComment(commentId, widget.post.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Komentar berhasil dihapus")),
      );
      widget.onCommentDeleted?.call(); // ✅ Panggil callback untuk refresh komentar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus komentar")),
      );
    }
  }

  /// **🔹 Fungsi untuk menampilkan bottom sheet konfirmasi hapus**
  Future<void> _showDeleteConfirmationSheet(BuildContext context, int commentId) async {
    HapticFeedback.mediumImpact(); // ✅ Efek getaran saat modal muncul
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // ✅ Sudut membulat
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 **Ikon Peringatan**
              const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),

              const SizedBox(height: 12),

              // 🔥 **Judul Konfirmasi**
              const Text(
                "Konfirmasi Hapus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // 📝 **Deskripsi**
              const Text(
                "Apakah Anda yakin ingin menghapus komentar ini? Aksi ini tidak dapat dibatalkan.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // 🔥 **Tombol Aksi**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ❌ **Batal**
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent), // ✅ Border merah
                      ),
                      child: const Text("Batal", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // 🗑 **Hapus**
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _deleteComment(commentId);
                      },
                      child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return FutureBuilder<int?>(
    future: authProvider.currentUserId,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final loggedInUserId = snapshot.data;

      return widget.post.comments.isNotEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.4, // ✅ Batasi tinggi ListView
              child: ListView.separated(
                shrinkWrap: true, // ✅ Pastikan shrinkWrap digunakan dengan benar
                physics: const AlwaysScrollableScrollPhysics(), // ✅ Pastikan bisa discroll
                itemCount: widget.post.comments.length,
                separatorBuilder: (context, index) => const Divider(
                  thickness: 0.5,
                  height: 16,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];

                  return Padding(
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
                            ],
                          ),
                        ),

                        // 🔹 **Titik Tiga Menu (Hanya untuk pemilik komentar)**
                        if (comment.user.id == loggedInUserId)
                          PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteConfirmationSheet(context, comment.id);
                            }
                          },
                          icon: const Icon(Icons.more_vert, color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // 🔹 Sudut membulat
                          ),
                          color: Colors.white, // 🔹 Background putih
                          elevation: 5, // 🔹 Efek shadow agar tampak melayang
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete, color: Colors.red), // 🔹 Icon merah
                                  const SizedBox(width: 12),
                                  Text(
                                    "Hapus Komentar",
                                    style: TextStyle(
                                      color: Colors.black, // 🔹 Warna teks hitam
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Belum ada komentar.", style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            );
    },
  );
}


  /// **🔹 Fungsi untuk menghasilkan warna avatar berdasarkan username**
  Color _generateColorFromUsername(String username) {
    final List<Color> colors = [Colors.blueAccent, Colors.green, Colors.deepOrange, Colors.purpleAccent, Colors.teal, Colors.redAccent];
    return colors[username.length % colors.length];
  }
}
