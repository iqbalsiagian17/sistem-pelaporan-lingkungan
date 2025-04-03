// domain/entities/report_entity.dart
import 'report_attachment_entity.dart';
import 'report_evidence_entity.dart';
import 'report_status_history_entity.dart';
import 'user_entity.dart';

class ReportEntity {
  final int id;
  final int userId;
  final String reportNumber;
  final String title;
  final String description;
  final String date;
  final String status;
  final int likes;
  final String? village;
  final String? locationDetails;
  final double latitude;
  final double longitude;
  final List<ReportAttachmentEntity> attachments;
  final UserEntity user;
  final List<ReportStatusHistoryEntity> statusHistory;
  final bool isSaved;
  final List<ReportEvidenceEntity> evidences;

  ReportEntity({
    required this.id,
    required this.userId,
    required this.reportNumber,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.likes,
    this.village,
    this.locationDetails,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.user,
    required this.statusHistory,
    required this.isSaved,
    required this.evidences,
  });
}
