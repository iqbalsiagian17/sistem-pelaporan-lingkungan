import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostActions extends ConsumerWidget {
  final ForumPostEntity post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(globalAuthServiceProvider); // ✅ pakai provider

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        authService.getAccessToken(),
        authService.getUserId(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();

        final String token = snapshot.data![0];
        final int userId = snapshot.data![1];

        final isLiked = post.isLiked; // ✅ Gunakan boolean dari entity
        final likeCount = post.likeCount;

        return Row(
          children: [
            GestureDetector(
              onTap: () async {
                final forumNotifier = ref.read(forumProvider.notifier);
                if (isLiked) {
                  await forumNotifier.unlikePost(post.id);
                } else {
                  await forumNotifier.likePost(post.id);
                }
                await forumNotifier.fetchAllPosts();
              },
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
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
                  "${post.comments.length}",
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
      },
    );
  }
}
