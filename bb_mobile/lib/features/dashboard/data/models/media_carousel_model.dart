import 'package:bb_mobile/core/constants/api.dart';
import '../../domain/entities/media_carousel_entity.dart';

class MediaCarouselModel extends MediaCarouselEntity {
  const MediaCarouselModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
  });

  factory MediaCarouselModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image'] ?? '';
    return MediaCarouselModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: rawImage.toString().startsWith('http')
          ? rawImage
          : "${ApiConstants.baseUrl}/$rawImage",
    );
  }
}
