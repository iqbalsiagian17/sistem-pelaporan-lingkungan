// forum_comment_edit_modal.dart
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showEditCommentModal(
  BuildContext context,
  WidgetRef ref,
  int commentId,
  String initialContent,
  int postId,
) async {
  final controller = TextEditingController(text: initialContent);
  HapticFeedback.mediumImpact();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Komentar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Tulis komentar...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66BB6A)),
                    onPressed: () async {
                      final newContent = controller.text.trim();
                      if (newContent.isEmpty) return;

                      final success = await ref.read(forumProvider.notifier).updateComment(
                            commentId: commentId,
                            content: newContent,
                            postId: postId,
                          );

                      if (context.mounted) {
                        Navigator.pop(context);
                        if (success) {
                          SnackbarHelper.showSnackbar(context, "Komentar berhasil diperbarui");
                        } else {
                          SnackbarHelper.showSnackbar(context, "Gagal memperbarui komentar", isError: true);
                        }
                      }
                    },
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
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
