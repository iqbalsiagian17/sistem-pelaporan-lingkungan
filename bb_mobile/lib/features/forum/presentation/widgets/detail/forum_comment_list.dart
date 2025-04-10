import 'package:bb_mobile/core/utils/date_utils.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_popup_menu.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumCommentList extends ConsumerWidget {
  final ForumPostEntity post;
  final VoidCallback? onCommentDeleted;

  const ForumCommentList({super.key, required this.post, this.onCommentDeleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(globalAuthServiceProvider).userId;

    if (post.comments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Belum ada komentar.", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.separated(
        itemCount: post.comments.length,
        separatorBuilder: (_, __) => const Divider(height: 16, color: Colors.grey, thickness: 0.5),
        itemBuilder: (context, index) {
          final comment = post.comments[index];
          final isOwner = comment.user.id == userId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _colorFromUsername(comment.user.username),
                  child: Text(
                    comment.user.username[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(comment.user.username,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(width: 6),
                          Text("• ${DateUtilsCustom.timeAgo(DateTime.parse(comment.createdAt))}",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(comment.content, style: const TextStyle(fontSize: 14, height: 1.4)),
                    ],
                  ),
                ),
                if (isOwner)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(context, ref, comment.id, post.id);
                      }
                    },
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10),
                            Text("Hapus Komentar"),
                          ],
                        ),
                      )
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, int commentId, int postId) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
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
                          SnackbarHelper.showSnackbar(
                            context,
                            "Komentar berhasil dihapus",
                          );
                        } else {
                          SnackbarHelper.showSnackbar(
                            context,
                            "Gagal menghapus komentar",
                            isError: true,
                          );
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

  Color _colorFromUsername(String username) {
    final colors = [
      Colors.blue,
      Color(0xFF66BB6A),
      Colors.purple,
      Colors.deepOrange,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[username.length % colors.length];
  }
}
