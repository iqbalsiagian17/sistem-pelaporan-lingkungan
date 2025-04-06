
import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';

class ForumCommentEntity {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String createdAt;
  final UserEntity user;

  ForumCommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.user,
  });
}
