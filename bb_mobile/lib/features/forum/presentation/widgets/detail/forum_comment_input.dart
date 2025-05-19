import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';

class ForumCommentInput extends ConsumerStatefulWidget {
  final int postId;
  final VoidCallback onCommentSent;

  const ForumCommentInput({
    super.key,
    required this.postId,
    required this.onCommentSent,
  });

  @override
  ConsumerState<ForumCommentInput> createState() => _ForumCommentInputState();
}

class _ForumCommentInputState extends ConsumerState<ForumCommentInput> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final replyTo = ref.read(forumProvider).replyToComment;

    final success = await ref.read(forumProvider.notifier).addComment(
      postId: widget.postId,
      content: content,
      parentId: replyTo?.id, // Ini null kalau tidak membalas
    );

    if (success) {
      _commentController.clear();
      ref.read(forumProvider.notifier).clearReplyTarget(); // 🧼 clear total
      widget.onCommentSent();
    }

    setState(() => _isLoading = false);
  }

  void _cancelReply() {
    ref.read(forumProvider.notifier).clearReplyTarget(); // ❌ buang parentId
  }

  @override
  Widget build(BuildContext context) {
    final replyTo = ref.watch(forumProvider).replyToComment;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyTo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Membalas @${replyTo.user.username}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Row(
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
                    : const Icon(
                        Icons.send,
                        color: Color.fromRGBO(76, 175, 80, 1),
                        size: 24,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
