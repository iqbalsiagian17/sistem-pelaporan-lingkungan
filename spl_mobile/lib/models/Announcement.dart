class AnnouncementItem {
  final int id;
  final String title;
  final String description;
  final String? file; // Bisa null jika tidak ada file
  final DateTime createdAt;
  final DateTime updatedAt;

  AnnouncementItem({
    required this.id,
    required this.title,
    required this.description,
    this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': file,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
