import 'package:bb_mobile/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';

class ForumAction extends ConsumerStatefulWidget {
  final int postId;
  final int commentCount;

  const ForumAction({
    super.key,
    required this.postId,
    required this.commentCount,
  });

  @override
  ConsumerState<ForumAction> createState() => _ForumActionState();
}

class _ForumActionState extends ConsumerState<ForumAction> {
  bool _isLiked = false;
  int _likeCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final forumState = ref.read(forumProvider);
    final post = forumState.posts.firstWhere((p) => p.id == widget.postId, orElse: () => forumState.selectedPost!);

    final userId = await ref.read(globalAuthServiceProvider).getUserId();

    if (mounted && post != null) {
      setState(() {
        _likeCount = post.likeCount;
        _isLiked = post.isLiked;
        _loading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    final notifier = ref.read(forumProvider.notifier);
    final userId = await ref.read(globalAuthServiceProvider).getUserId();

    if (_isLiked) {
      await notifier.unlikePost(widget.postId);
    } else {
      await notifier.likePost(widget.postId);
    }

    // Refresh post data
    await notifier.fetchPostById(widget.postId);

    // Update UI
    _loadLikeStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isLiked),
                        color: _isLiked ? Colors.red : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$_likeCount",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                "${widget.commentCount} Komentar",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
