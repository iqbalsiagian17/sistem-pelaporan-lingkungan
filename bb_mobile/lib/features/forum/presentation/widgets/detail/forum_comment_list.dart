// forum_comment_list.dart
import 'package:bb_mobile/core/providers/auth_provider.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/detail/forum_comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumCommentList extends ConsumerStatefulWidget {
  final ForumPostEntity post;
  final VoidCallback? onCommentDeleted;

  const ForumCommentList({
    super.key,
    required this.post,
    this.onCommentDeleted,
  });

  @override
  ConsumerState<ForumCommentList> createState() => _ForumCommentListState();
}

class _ForumCommentListState extends ConsumerState<ForumCommentList> {
  final Map<int, bool> _expandedReplies = {};

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(globalAuthServiceProvider).userId;

    if (widget.post.comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Belum ada komentar.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    final parentComments = widget.post.comments.where((c) => c.parentId == null).toList();

    return Column(
      children: parentComments
          .map((parent) => _buildCommentWithReplies(context, parent, widget.post, userId!, 0))
          .expand((e) => e)
          .toList(),
    );
  }

  List<Widget> _buildCommentWithReplies(
    BuildContext context,
    dynamic parent,
    ForumPostEntity post,
    int userId,
    int depth,
  ) {
    final isOwner = parent.user.id != null && parent.user.id == userId;

    final commentWidget = Padding(
      padding: EdgeInsets.only(left: depth * 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (depth > 0)
            Container(
              width: 24,
              alignment: Alignment.topCenter,
              child: Container(
                width: 2,
                height: 80,
                color: Colors.grey.shade300,
              ),
            ),
          Expanded(
            child: ForumCommentItem(
              post: post,
              comment: parent,
              isOwner: isOwner,
              onCommentDeleted: widget.onCommentDeleted,
            ),
          ),
        ],
      ),
    );

    final allReplies = post.comments.where((c) => c.parentId == parent.id).toList();
    final isExpanded = _expandedReplies[parent.id] ?? false;
    final visibleReplies = isExpanded ? allReplies : [];

    final replyWidgets = visibleReplies
        .map((reply) => _buildCommentWithReplies(context, reply, post, userId, depth + 1))
        .expand((e) => e)
        .toList();

    if (allReplies.isNotEmpty) {
      replyWidgets.add(
        Padding(
padding: EdgeInsets.only(left: depth * 24 + 40, top: 4, bottom: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expandedReplies[parent.id] = !isExpanded;
              });
            },
            child: Text(
              isExpanded
                  ? "Sembunyikan balasan"
                  : "Tampilkan ${allReplies.length} balasan",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return [commentWidget, ...replyWidgets];
  }
}
