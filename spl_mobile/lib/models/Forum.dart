import 'package:spl_mobile/models/ForumComment.dart';
import 'package:spl_mobile/models/ForumImage.dart';
import 'package:spl_mobile/models/User.dart';

/// ✅ Model untuk Postingan Forum
class ForumPost {
  final int id;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final int likes;
  final bool isPinned;
  final User user;
  final List<ForumImage> images;
  final List<ForumComment> comments;

  ForumPost({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.images,
    required this.comments,
    required this.likes,
    required this.isPinned,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
      images: (json['images'] as List)
          .map((img) => ForumImage.fromJson(img))
          .toList(),
      comments: (json['comments'] as List)
          .map((cmt) => ForumComment.fromJson(cmt))
          .toList(),
      likes: json['likes'] ?? 0,
isPinned: json['is_pinned'] ?? false, // ✅ Ambil langsung boolean
    );
  }

  
}
