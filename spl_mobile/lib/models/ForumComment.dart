import 'package:spl_mobile/models/User.dart';

/// ✅ Model untuk Komentar di Forum
class ForumComment {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String createdAt;
  final User user;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    return ForumComment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['createdAt'],
      user: User.fromJson(json['user']),
    );
  }
}
