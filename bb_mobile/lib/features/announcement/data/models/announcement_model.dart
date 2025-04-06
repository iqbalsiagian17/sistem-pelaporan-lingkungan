import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';

class AnnouncementModel {
  final int id;
  final String title;
  final String description;
  final String? file;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// ✅ Tambahkan method ini
  AnnouncementEntity toEntity() {
    return AnnouncementEntity(
      id: id,
      title: title,
      description: description,
      file: file,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
