// forum_comment_delete_modal.dart
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showDeleteConfirmation(
  BuildContext context,
  WidgetRef ref,
  int commentId,
  int postId,
  VoidCallback? onCommentDeleted,
) async {
  HapticFeedback.mediumImpact();

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text("Konfirmasi Hapus", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text("Yakin ingin menghapus komentar ini?", textAlign: TextAlign.center),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () async {
                      final success = await ref.read(forumProvider.notifier).deleteComment(commentId, postId);

                      if (context.mounted) {
                        Navigator.pop(context);
                        if (success) {
                          onCommentDeleted?.call();
                          SnackbarHelper.showSnackbar(context, "Komentar berhasil dihapus");
                        } else {
                          SnackbarHelper.showSnackbar(context, "Gagal menghapus komentar", isError: true);
                        }
                      }
                    },
                    child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}