// forum_comment_utils.dart
import 'package:flutter/material.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';

String? getParentUsername(ForumPostEntity post, int? parentId) {
  if (parentId == null) return null;
  final parent = post.comments.firstWhere(
    (c) => c.id == parentId,
    orElse: () => null as dynamic,
  );
  return parent?.user.username;
}

Widget buildFallbackAvatar(String username, {double radius = 20}) {
  final color = _colorFromUsername(username);
  final initial = username.isNotEmpty ? username[0].toUpperCase() : "?";
  return CircleAvatar(
    radius: radius,
    backgroundColor: color,
    child: Text(
      initial,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: radius * 0.9, // Ukuran teks mengikuti radius
      ),
    ),
  );
}


Color _colorFromUsername(String username) {
  final colors = [
    Colors.blue,
    const Color(0xFF66BB6A),
    Colors.purple,
    Colors.deepOrange,
    Colors.teal,
    Colors.indigo,
  ];
  return colors[username.length % colors.length];
}