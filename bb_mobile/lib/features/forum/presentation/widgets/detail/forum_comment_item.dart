// forum_comment_item.dart
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/date_utils.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_comment_entity.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_delete_modal.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_edit_modal.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_utils.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/user_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumCommentItem extends ConsumerWidget {
  final ForumPostEntity post;
  final ForumCommentEntity comment;
  final bool isOwner;
  final VoidCallback? onCommentDeleted;

  const ForumCommentItem({
    super.key,
    required this.post,
    required this.comment,
    required this.isOwner,
    this.onCommentDeleted,
  });

  void _showUserInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserProfileModal(user: comment.user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasImage = comment.user.profilePicture != null && comment.user.profilePicture!.isNotEmpty;
    final imageUrl = hasImage
        ? "${ApiConstants.baseUrl}/${comment.user.profilePicture!.replaceAll(r'\\', '/')}"
        : null;

    final isReply = comment.parentId != null;
    final replyingToUsername = getParentUsername(post, comment.parentId);

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 5 : 12,
        right: 12,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showUserInfo(context),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      width: isReply ? 30 : 40, // ⬅️ lebih kecil jika reply
                      height: isReply ? 30 : 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                                buildFallbackAvatar(comment.user.username, radius: isReply ? 15 : 20),

                    )
                  :
                        buildFallbackAvatar(comment.user.username, radius: isReply ? 15 : 20),

            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showUserInfo(context),
                      child: Text(
                        comment.user.username.length > 20
                            ? '${comment.user.username.substring(0, 15)}...'
                            : comment.user.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isReply ? 12 : 14, // ⬅️ lebih kecil untuk reply
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateUtilsCustom.shortTimeAgo(DateTime.parse(comment.createdAt)),
                      style: TextStyle(color: Colors.grey.shade500, fontSize: isReply ? 10 : 12,),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isReply && replyingToUsername != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "Membalas ${replyingToUsername}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    Text(
                      comment.content,
                      style: TextStyle(fontSize: isReply ? 13 : 14, height: 1.4),
                    ),
                    if (comment.isEdited == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          " (diubah)",
                          style: TextStyle(
                            fontSize: isReply ? 10 : 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
  onSelected: (value) {
    if (value == 'delete') {
      showDeleteConfirmation(context, ref, comment.id, post.id, onCommentDeleted);
    } else if (value == 'edit') {
      showEditCommentModal(context, ref, comment.id, comment.content, post.id);
    } else if (value == 'reply') {
      // Cek apakah comment yang akan dibalas adalah reply?
      if (comment.parentId != null) {
        // Cari komentar root-nya
        final rootComment = post.comments.firstWhere(
          (c) => c.id == comment.parentId,
          orElse: () => comment,
        );
        // Atur reply target ke root comment, bukan nested
        ref.read(forumProvider.notifier).setReplyTarget(rootComment);
      } else {
        // Kalau bukan reply, balas langsung
        ref.read(forumProvider.notifier).setReplyTarget(comment);
      }
    }

  },
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,
  elevation: 4,
  icon: const Icon(Icons.more_vert, color: Colors.black),
  itemBuilder: (context) => isOwner
      ? [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: const [
                Icon(Icons.edit_outlined, color: Colors.blue),
                SizedBox(width: 8),
                Text("Edit Komentar"),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: const [
                Icon(Icons.delete_outline, color: Colors.red),
                SizedBox(width: 8),
                Text("Hapus Komentar"),
              ],
            ),
          ),
        ]
      : [
          PopupMenuItem(
            value: 'reply',
            child: Row(
              children: const [
                Icon(Icons.reply_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text("Balas Komentar"),
              ],
            ),
          ),
        ],
        ),

        ],
      ),
    );
  }
}
