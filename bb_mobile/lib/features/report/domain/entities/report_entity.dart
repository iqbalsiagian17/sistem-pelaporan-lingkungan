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
  final int total_likes;
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
    required this.total_likes,
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

  factory ReportEntity.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('report') ? json['report'] : json;

    return ReportEntity(
      id: data['id'],
      userId: data['user_id'],
      reportNumber: data['report_number'],
      title: data['title'],
      description: data['description'],
      date: data['date'],
      status: data['status'],
      total_likes: data['total_likes'] ?? 0,
      village: data['village'],
      locationDetails: data['location_details'],
      latitude: double.tryParse(data['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(data['longitude'].toString()) ?? 0.0,
      attachments: (data['attachments'] as List<dynamic>? ?? [])
          .map((e) => ReportAttachmentEntity.fromJson(e))
          .toList(),
      user: UserEntity.fromJson(data['user'] ?? {}),
      statusHistory: (data['statusHistory'] as List<dynamic>? ?? [])
          .map((e) => ReportStatusHistoryEntity.fromJson(e))
          .toList(),
      isSaved: data['is_saved'] ?? false,
      evidences: (data['evidences'] as List<dynamic>? ?? [])
          .map((e) => ReportEvidenceEntity.fromJson(e))
          .toList(),
    );
  }
}
