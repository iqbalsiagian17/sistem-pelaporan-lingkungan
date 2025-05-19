import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';

class PostActions extends ConsumerWidget {
  final ForumPostEntity post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumState = ref.watch(forumProvider);
    final forumNotifier = ref.read(forumProvider.notifier);

    // Ambil versi post terbaru dari state
    final currentPost = forumState.posts.firstWhere(
      (p) => p.id == post.id,
      orElse: () => forumState.selectedPost ?? post,
    );

    final isLiked = currentPost.isLiked;
    final likeCount = currentPost.likeCount;
    final commentCount = currentPost.comments.length;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            if (isLiked) {
              await forumNotifier.unlikePost(post.id);
              forumNotifier.updatePostLikeStatus(post.id, false, likeCount - 1);
            } else {
              await forumNotifier.likePost(post.id);
              forumNotifier.updatePostLikeStatus(post.id, true, likeCount + 1);
            }
          },
          child: AnimatedScale(
            scale: isLiked ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLiked ? Colors.red.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Icon(
                    isLiked ? PhosphorIcons.heartFill : PhosphorIcons.heart,
                    color: isLiked ? Colors.red : Colors.grey.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "$likeCount",
                  style: TextStyle(
                    color: isLiked ? Colors.red : Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Icon(
              PhosphorIcons.chatCircleText,
              size: 22,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              "$commentCount",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
