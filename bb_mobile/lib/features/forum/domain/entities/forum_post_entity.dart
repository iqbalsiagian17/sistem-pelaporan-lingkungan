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
}
