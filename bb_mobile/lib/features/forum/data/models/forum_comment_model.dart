import 'package:bb_mobile/features/forum/domain/entities/forum_comment_entity.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';

class ForumCommentModel {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final bool isEdited; // ✅ Tambahan
  final String createdAt;
  final UserModel user;
  final int? parentId; // 🔁 gunakan ID saja, bukan object

  ForumCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.isEdited = false, // ✅ Tambahan
    required this.createdAt,
    required this.user,
    this.parentId,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    return ForumCommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      isEdited: json['is_edited'] ?? false, // ✅ Mapping dari backend
      createdAt: json['createdAt'],
      user: UserModel.fromJson(json['user']),
      parentId: json['parent_id'], // 🔁 ambil ID


    );
  }

  ForumCommentEntity toEntity() {
    return ForumCommentEntity(
      id: id,
      postId: postId,
      userId: userId,
      content: content,
      isEdited: isEdited, // ✅ Mapping ke entity
      createdAt: createdAt,
      user: user,
      parentId: parentId, // mapping id saja
    );
  }
}
