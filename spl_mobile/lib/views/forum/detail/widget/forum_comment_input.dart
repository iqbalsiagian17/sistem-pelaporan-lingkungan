import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum_provider.dart';

class ForumCommentInput extends StatefulWidget {
  final int postId; // ✅ ID Post untuk komentar

  const ForumCommentInput({super.key, required this.postId});

  @override
  _ForumCommentInputState createState() => _ForumCommentInputState();
}

class _ForumCommentInputState extends State<ForumCommentInput> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false; // ✅ Indikator loading saat komentar dikirim

  /// **Fungsi untuk mengirim komentar**
  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) return; // ⛔ Cegah komentar kosong

    setState(() => _isLoading = true);
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);

    bool success = await forumProvider.addComment(
      postId: widget.postId,
      content: _commentController.text.trim(),
    );

    if (success) {
      _commentController.clear(); // ✅ Reset input setelah berhasil
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "Tulis komentar...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: Colors.blue),
            onPressed: _isLoading ? null : _sendComment, // ✅ Cegah multi-klik saat loading
          ),
        ],
      ),
    );
  }
}
