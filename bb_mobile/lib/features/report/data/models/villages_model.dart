import 'package:bb_mobile/features/report/domain/entities/village_entity.dart';

class VillageModel {
  final int id;
  final String name;
  final Map<String, dynamic>? boundary; // GeoJSON polygon

  VillageModel({
    required this.id,
    required this.name,
    this.boundary,
  });
  

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      id: json['id'],
      name: json['name'],
      boundary: json['boundary'] != null ? Map<String, dynamic>.from(json['boundary']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (boundary != null) 'boundary': boundary,
      };
      
}

extension VillageModelMapper on VillageModel {
  VillageEntity toEntity() => VillageEntity(
    id: id,
    name: name,
    boundary: boundary,
  );
}
