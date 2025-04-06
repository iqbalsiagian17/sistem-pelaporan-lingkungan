import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_image_entity.dart';

class ForumImageModel {
  final int id;
  final int postId;
  final String imageUrl;

  ForumImageModel({
    required this.id,
    required this.postId,
    required this.imageUrl,
  });

  factory ForumImageModel.fromJson(Map<String, dynamic> json) {
    return ForumImageModel(
      id: json['id'],
      postId: json['post_id'],
      imageUrl: "${ApiConstants.baseUrl}/${json['image']}",
    );
  }

  ForumImageEntity toEntity() {
    return ForumImageEntity(
      id: id,
      postId: postId,
      imageUrl: imageUrl,
    );
  }
}
