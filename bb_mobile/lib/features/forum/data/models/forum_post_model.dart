import 'package:bb_mobile/features/forum/data/models/forum_comment_model.dart';
import 'package:bb_mobile/features/forum/data/models/forum_image_model.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';

class ForumPostModel {
  final int id;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final int likes;
  final bool isPinned;
  final bool isLiked;
  final UserModel user;
  final List<ForumImageModel> images;
  final List<ForumCommentModel> comments;

  ForumPostModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.isPinned,
    required this.isLiked, 
    required this.user,
    required this.images,
    required this.comments,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) {

      print("🧪 Debug is_liked: ${json['is_liked']} for post: ${json['id']}");

    return ForumPostModel(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      likes: json['likes'] ?? 0,
      isPinned: json['is_pinned'] ?? false,
      isLiked: json['is_liked'] ?? false, 
      user: UserModel.fromJson(json['user']),
      images: (json['images'] as List)
          .map((img) => ForumImageModel.fromJson(img))
          .toList(),
      comments: (json['comments'] as List)
          .map((cmt) => ForumCommentModel.fromJson(cmt))
          .toList(),
    );
  }

  ForumPostEntity toEntity() {
    return ForumPostEntity(
      id: id,
      userId: userId,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likes: likes,
      isPinned: isPinned,
      likeCount: likes,
      isLiked: isLiked, 
      user: user,
      images: images.map((img) => img.toEntity()).toList(),
      comments: comments.map((cmt) => cmt.toEntity()).toList(),
    );
  }
}
