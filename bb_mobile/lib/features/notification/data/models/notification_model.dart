import 'package:bb_mobile/features/notification/domain/entities/notification_entity.dart';

class UserNotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final String sentBy;
  final DateTime createdAt;
  final int? reportId;

  UserNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.sentBy,
    required this.createdAt,
    this.reportId
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      id: json['id'],
      title: json['title'] ?? 'Tanpa Judul',
      message: json['message'] ?? '-',
      isRead: json['is_read'] ?? false,
      type: json['type'] ?? 'info',
      sentBy: json['sent_by'] ?? 'system',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      reportId: json['report_id'],
    );
  }

  /// Konversi ke entitas
UserNotificationEntity toEntity() {
  return UserNotificationEntity(
    id: id,
    title: title,
    message: message,
    isRead: isRead,
    type: type,
    reportId: reportId, // ✅ Tambahkan ini
    createdAt: createdAt,
    updatedAt: createdAt, // atau DateTime.now() jika tidak punya
  );
}

  /// Tambahkan copyWith juga jika diperlukan
  UserNotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    String? type,
    String? sentBy,
    DateTime? createdAt,
  }) {
    return UserNotificationModel(
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
