import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';

class PostActions extends ConsumerWidget {
  final ForumPostEntity post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumState = ref.watch(forumProvider);
    final forumNotifier = ref.read(forumProvider.notifier);

    // Ambil versi post terbaru dari state (bukan dari parameter)
    final currentPost = forumState.posts.firstWhere(
      (p) => p.id == post.id,
      orElse: () => forumState.selectedPost ?? post,
    );

    final isLiked = currentPost.isLiked;
    final likeCount = currentPost.likeCount;

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            if (isLiked) {
              await forumNotifier.unlikePost(post.id);
              forumNotifier.updatePostLikeStatus(post.id, false, likeCount - 1);
            } else {
              await forumNotifier.likePost(post.id);
              forumNotifier.updatePostLikeStatus(post.id, true, likeCount + 1);
            }
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLiked ? Colors.red.withOpacity(0.2) : Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isLiked),
                    color: isLiked ? Colors.red : Colors.grey.shade700,
                    size: 20,
                  ),
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
        const SizedBox(width: 15),
        Row(
          children: [
            const Icon(Icons.mode_comment_outlined, size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              "${currentPost.comments.length}",
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
