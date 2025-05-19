import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';

class ForumCommentEntity {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String createdAt;
  final UserEntity user;
  final bool isEdited;
  final int? parentId;

  ForumCommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.isEdited,
    this.parentId,
  });

  ForumCommentEntity copyWith({
    int? id,
    int? postId,
    int? userId,
    String? content,
    String? createdAt,
    UserEntity? user,
    bool? isEdited,
    int? parentId,
  }) {
    return ForumCommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      isEdited: isEdited ?? this.isEdited,
      parentId: parentId ?? this.parentId,
    );
  }
}
