import 'package:bb_mobile/features/report/domain/entities/report_attachment_entity.dart';
import 'package:bb_mobile/features/report/domain/entities/report_status_history_entity.dart';
import 'package:bb_mobile/features/report/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/report/domain/entities/report_evidence_entity.dart';

class ReportSaveEntity {
  final int reportId;
  final String title;
  final String description;
  final String location;
  final String date;
  final String status;
  final double latitude;
  final double longitude;
  final List<ReportAttachmentEntity> attachments;
  final String imageUrl;
  final int userId;
  final String reportNumber;
  final UserEntity user;
  final List<ReportStatusHistoryEntity> statusHistory;
  final bool isSaved;
  final List<ReportEvidenceEntity> evidences;

  ReportSaveEntity({
    required this.reportId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.imageUrl,
    required this.userId,
    required this.reportNumber,
    required this.user,
    required this.statusHistory,
    required this.isSaved,
    required this.evidences,
  });
}
