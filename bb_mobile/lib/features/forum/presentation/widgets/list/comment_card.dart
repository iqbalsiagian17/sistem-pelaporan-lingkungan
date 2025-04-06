import 'package:bb_mobile/features/forum/domain/entities/forum_comment_entity.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final ForumCommentEntity comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green.shade200,
        child: Text(
          comment.user.username[0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        comment.user.username,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          comment.content,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
