import 'package:bb_mobile/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/forum/presentation/providers/forum_provider.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';

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
    _initPostLikeState();
  }

  void _initPostLikeState() {
    final forumState = ref.read(forumProvider);
    final selected = forumState.selectedPost;

    try {
      final post = forumState.posts.firstWhere(
        (p) => p.id == widget.postId,
        orElse: () {
          if (selected != null) return selected;
          throw Exception("Post not found");
        },
      );

      setState(() {
        _isLiked = post.isLiked;
        _likeCount = post.likeCount;
        _loading = false;
      });
    } catch (e) {
      // Handle error (bisa tampilkan error message atau kosongkan widget)
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    final notifier = ref.read(forumProvider.notifier);

    if (_isLiked) {
      await notifier.unlikePost(widget.postId);
      notifier.updatePostLikeStatus(widget.postId, false, _likeCount - 1);
      setState(() {
        _isLiked = false;
        _likeCount -= 1;
      });
    } else {
      await notifier.likePost(widget.postId);
      notifier.updatePostLikeStatus(widget.postId, true, _likeCount + 1);
      setState(() {
        _isLiked = true;
        _likeCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

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
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isLiked),
                        color: _isLiked ? Colors.red : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_likeCount',
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
