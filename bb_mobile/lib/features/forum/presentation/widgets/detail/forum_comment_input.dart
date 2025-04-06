import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';

class ForumCommentInput extends ConsumerStatefulWidget {
  final int postId;
  final VoidCallback onCommentSent;

  const ForumCommentInput({super.key, required this.postId, required this.onCommentSent});

  @override
  ConsumerState<ForumCommentInput> createState() => _ForumCommentInputState();
}

class _ForumCommentInputState extends ConsumerState<ForumCommentInput> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final success = await ref.read(forumProvider.notifier).addComment(
          postId: widget.postId,
          content: _commentController.text.trim(),
        );

    if (success) {
      _commentController.clear();
      widget.onCommentSent();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Tulis komentar...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _isLoading ? null : _sendComment,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send, color: Color.fromRGBO(76, 175, 80, 1), size: 24),
          ),
        ],
      ),
    );
  }
}
