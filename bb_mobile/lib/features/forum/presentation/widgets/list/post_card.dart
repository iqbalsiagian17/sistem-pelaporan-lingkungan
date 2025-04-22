import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/pages/detail/forum_detail_view.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_actions.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_header.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_image_grid.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/user_profile_modal.dart';
import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  final ForumPostEntity post;

  const PostCard({super.key, required this.post});

  void _showUserInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserProfileModal(user: post.user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProfileProvider);

    return userState.when(
      data: (user) {
        final isOwner = post.user.id == user.id;

        return Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForumDetailView(post: post),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostHeader(
                      post: post,
                      onUserTap: () => _showUserInfo(context),
                    ),
                    const SizedBox(height: 8),
                    Text(post.content, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    if (post.images.isNotEmpty)
                      PostImageGrid(
                        images: post.images
                            .map((img) => img.imageUrl)
                            .where((url) => url.isNotEmpty)
                            .toList(),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: PostActions(post: post)),
                        if (post.isPinned && isOwner) _pinnedBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (post.isPinned && !isOwner)
              Positioned(top: 6, right: 12, child: _pinnedBadge()),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _pinnedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: const [
          Icon(Icons.push_pin, size: 14, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            'Tersemat',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
