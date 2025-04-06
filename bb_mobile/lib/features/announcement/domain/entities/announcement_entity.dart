class AnnouncementEntity {
  final int id;
  final String title;
  final String description;
  final String? file;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnnouncementEntity({
    required this.id,
    required this.title,
    required this.description,
    this.file,
    required this.createdAt,
    required this.updatedAt,
  });
}
