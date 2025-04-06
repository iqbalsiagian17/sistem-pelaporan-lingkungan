class UserNotificationEntity {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final String sentBy;
  final DateTime createdAt;

  UserNotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.sentBy,
    required this.createdAt,
  });

  UserNotificationEntity copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    String? type,
    String? sentBy,
    DateTime? createdAt,
  }) {
    return UserNotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      sentBy: sentBy ?? this.sentBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
