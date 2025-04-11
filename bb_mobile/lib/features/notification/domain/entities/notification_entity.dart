class UserNotificationEntity {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final int? reportId; // <-- ✅ Tambahkan ini
  final DateTime createdAt;
  final DateTime updatedAt;

  UserNotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.reportId, // <-- ✅ Pastikan nullable
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserNotificationEntity.fromJson(Map<String, dynamic> json) {
    return UserNotificationEntity(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'],
      reportId: json['report_id'], // ✅ Ambil dari JSON
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UserNotificationEntity copyWith({
    bool? isRead,
  }) {
    return UserNotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      reportId: reportId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
