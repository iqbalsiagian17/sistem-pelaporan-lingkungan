import 'package:flutter/material.dart';
import 'package:spl_mobile/models/ForumComment.dart';

class CommentCard extends StatelessWidget {
  final ForumComment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(comment.user.username[0].toUpperCase()),
      ),
      title: Text(comment.user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment.content),
    );
  }
}
