import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';
import 'forum_comment_entity.dart';
import 'forum_image_entity.dart';

class ForumPostEntity {
  final int id;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final int likes;
  final bool isPinned;
  final int likeCount;
  final bool isLiked;
  final UserEntity user;
  final List<ForumImageEntity> images;
  final List<ForumCommentEntity> comments;

  ForumPostEntity({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.isPinned,
    required this.likeCount,
    required this.isLiked,
    required this.user,
    required this.images,
    required this.comments,
  });

  // Getter for comment count
  int get commentCount => comments.length;

  ForumPostEntity copyWith({
    int? id,
    int? userId,
    String? content,
    String? createdAt,
    String? updatedAt,
    int? likes,
    bool? isPinned,
    int? likeCount,
    bool? isLiked,
    UserEntity? user,
    List<ForumImageEntity>? images,
    List<ForumCommentEntity>? comments,
  }) {
    return ForumPostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      isPinned: isPinned ?? this.isPinned,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      user: user ?? this.user,
      images: images ?? this.images,
      comments: comments ?? this.comments,
    );
  }
}
