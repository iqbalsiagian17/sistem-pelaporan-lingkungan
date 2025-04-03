import 'user_entity.dart';

class ReportStatusHistoryEntity {
  final int id;
  final String previousStatus;
  final String newStatus;
  final String message;
  final String createdAt;
  final UserEntity admin;

  ReportStatusHistoryEntity({
    required this.id,
    required this.previousStatus,
    required this.newStatus,
    required this.message,
    required this.createdAt,
    required this.admin,
  });
}
