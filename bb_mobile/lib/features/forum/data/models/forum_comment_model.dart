import 'package:bb_mobile/features/forum/domain/entities/forum_comment_entity.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';

class ForumCommentModel {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String createdAt;
  final UserModel user;

  ForumCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    return ForumCommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['createdAt'],
      user: UserModel.fromJson(json['user']),
    );
  }

  ForumCommentEntity toEntity() {
    return ForumCommentEntity(
      id: id,
      postId: postId,
      userId: userId,
      content: content,
      createdAt: createdAt,
      user: user,
    );
  }
}
