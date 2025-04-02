class UserNotification {
  final int id;
  final String title;
  final String message;
  bool isRead;
  final String type;
  final DateTime createdAt;

  UserNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json["id"],
      title: json["title"],
      message: json["message"],
      isRead: json["is_read"] ?? false,
      type: json["type"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  // ✅ Tambahkan method copyWith
  UserNotification copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    String? type,
    DateTime? createdAt,
  }) {
    return UserNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
