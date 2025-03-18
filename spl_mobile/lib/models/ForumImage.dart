import 'package:spl_mobile/core/constants/api.dart';

/// ✅ Model untuk Gambar di Postingan Forum
class ForumImage {
  final int id;
  final int postId;
  final String imageUrl;

  ForumImage({
    required this.id,
    required this.postId,
    required this.imageUrl,
  });

  factory ForumImage.fromJson(Map<String, dynamic> json) {
    return ForumImage(
      id: json['id'],
      postId: json['post_id'],
      imageUrl: "${ApiConstants.baseUrl}/${json['image']}",
    );
  }
}
