import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Forum.dart';

class ForumPostContent extends StatelessWidget {
  final ForumPost post;

  const ForumPostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Text(
      post.content,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
