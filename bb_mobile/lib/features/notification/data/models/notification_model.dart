import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';

class UserNotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final String sentBy;
  final int? userId;
  final int? reportId;
  final String roleTarget;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.sentBy,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.reportId,
    required this.roleTarget,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      id: json['id'],
      title: json['title'] ?? 'Tanpa Judul',
      message: json['message'] ?? '-',
      isRead: json['is_read'] ?? false,
      type: json['type'] ?? 'info',
      sentBy: json['sent_by'] ?? 'system',
      userId: json['user_id'],
      reportId: json['report_id'],
      roleTarget: json['role_target'] ?? 'user',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Konversi ke entitas
  UserNotificationEntity toEntity() {
    return UserNotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead,
      userId: userId,
      reportId: reportId,
      roleTarget: roleTarget,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  UserNotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    String? type,
    String? sentBy,
    int? userId,
    int? reportId,
    String? roleTarget,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      sentBy: sentBy ?? this.sentBy,
      userId: userId ?? this.userId,
      reportId: reportId ?? this.reportId,
      roleTarget: roleTarget ?? this.roleTarget,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
