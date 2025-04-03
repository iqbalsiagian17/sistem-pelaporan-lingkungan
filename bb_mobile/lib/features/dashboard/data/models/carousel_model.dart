import 'package:bb_mobile/core/constants/api.dart';

import '../../domain/entities/carousel_entity.dart';

class CarouselModel extends CarouselEntity {
  const CarouselModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'].toString().startsWith('http')
        ? json['image']
        : "${ApiConstants.baseUrl}/${json['image']}",

    );
  }
}
