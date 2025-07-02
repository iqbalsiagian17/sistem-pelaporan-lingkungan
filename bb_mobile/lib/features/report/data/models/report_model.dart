import 'package:bb_mobile/features/report/data/models/villages_model.dart';
import 'report_attachment_model.dart';
import 'report_evidence_model.dart';
import 'report_status_history_model.dart';
import 'user_model.dart';
import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  final int? villageId;
  final VillageModel? villageModel;
  final String createdAt;
  final String updatedAt;

  // Getter untuk boundary desa (GeoJSON)
  Map<String, dynamic>? get boundary => villageModel?.boundary;

  ReportModel({
    required int id,
    required int userId,
    required String reportNumber,
    required String title,
    required String description,
    required String date,
    required String status,
    required int total_likes,
    this.villageId,
    this.villageModel,
    String? locationDetails,
    required double latitude,
    required double longitude,
    required List<ReportAttachmentModel> attachments,
    required UserModel user,
    required List<ReportStatusHistoryModel> statusHistory,
    required bool isSaved,
    required List<ReportEvidenceModel> evidences,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          userId: userId,
          reportNumber: reportNumber,
          title: title,
          description: description,
          date: date,
          status: status,
          total_likes: total_likes,
          village: villageModel?.name,
          locationDetails: locationDetails,
          latitude: latitude,
          longitude: longitude,
          attachments: attachments,
          user: user,
          statusHistory: statusHistory,
          isSaved: isSaved,
          evidences: evidences,
        );

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final data = (json['report'] is Map<String, dynamic>) ? json['report'] : json;

    return ReportModel(
      id: data['id'] ?? 0,
      userId: data['user_id'] ?? 0,
      reportNumber: data['report_number'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      status: data['status'] ?? 'pending',
      total_likes: data['total_likes'] ?? 0,
      villageId: data['village_id'],
      villageModel: data['village'] != null ? VillageModel.fromJson(data['village']) : null,
      locationDetails: data['location_details'],
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      attachments: (data['attachments'] as List<dynamic>? ?? [])
          .map((e) => ReportAttachmentModel.fromJson(e))
          .toList(),
      user: UserModel.fromJson(data['user'] ?? {}),
      statusHistory: (data['statusHistory'] as List<dynamic>? ?? [])
          .map((e) => ReportStatusHistoryModel.fromJson(e))
          .toList(),
      isSaved: data['is_saved'] ?? false,
      evidences: (data['evidences'] as List<dynamic>? ?? [])
          .map((e) => ReportEvidenceModel.fromJson(e))
          .toList(),
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'report_number': reportNumber,
        'title': title,
        'description': description,
        'date': date,
        'status': status,
        'total_likes': total_likes,
        'village_id': villageId,
        'village': villageModel?.toJson(),
        'location_details': locationDetails,
        'latitude': latitude,
        'longitude': longitude,
        'attachments':
            attachments.map((e) => (e as ReportAttachmentModel).toJson()).toList(),
        'user': (user as UserModel).toJson(),
        'statusHistory':
            statusHistory.map((e) => (e as ReportStatusHistoryModel).toJson()).toList(),
        'is_saved': isSaved,
        'evidences':
            evidences.map((e) => (e as ReportEvidenceModel).toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      id: entity.id,
      userId: entity.userId,
      reportNumber: entity.reportNumber,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      status: entity.status,
      total_likes: entity.total_likes,
      villageId: null, // bisa diganti jika ada field di ReportEntity
      villageModel: entity.village != null
          ? VillageModel(id: 0, name: entity.village!)
          : null,
      locationDetails: entity.locationDetails,
      latitude: entity.latitude,
      longitude: entity.longitude,
      attachments: entity.attachments
          .map((e) => ReportAttachmentModel.fromEntity(e))
          .toList(),
      user: UserModel.fromEntity(entity.user),
      statusHistory: entity.statusHistory
          .map((e) => ReportStatusHistoryModel.fromEntity(e))
          .toList(),
      isSaved: entity.isSaved,
      evidences:
          entity.evidences.map((e) => ReportEvidenceModel.fromEntity(e)).toList(),
      createdAt: '', // isi jika diperlukan
      updatedAt: '',
    );
  }
}
