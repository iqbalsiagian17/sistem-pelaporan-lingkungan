class UserNotificationEntity {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final int? userId;
  final int? reportId;
  final String roleTarget;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserNotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.userId,
    this.reportId,
    required this.roleTarget,
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
      userId: json['user_id'],
      reportId: json['report_id'],
      roleTarget: json['role_target'] ?? 'user',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UserNotificationEntity copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    int? userId,
    int? reportId,
    String? roleTarget,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserNotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      reportId: reportId ?? this.reportId,
      roleTarget: roleTarget ?? this.roleTarget,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
