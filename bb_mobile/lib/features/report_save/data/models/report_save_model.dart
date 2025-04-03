import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/report/data/models/report_attachment_model.dart';
import 'package:bb_mobile/features/report/data/models/report_evidence_model.dart';
import 'package:bb_mobile/features/report/data/models/report_status_history_model.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';

class ReportSaveModel extends ReportSaveEntity {
  ReportSaveModel({
    required super.reportId,
    required super.title,
    required super.description,
    required super.location,
    required super.date,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.attachments,
    required super.imageUrl,
    required super.userId,
    required super.reportNumber,
    required super.user,
    required super.statusHistory,
    required super.isSaved,
    required super.evidences,
  });

  factory ReportSaveModel.fromJson(Map<String, dynamic> json) {
    final reportData = json.containsKey('report') ? json['report'] : json;

    List<ReportAttachmentModel> attachments = [];
    if (reportData['attachments'] is List) {
      attachments = (reportData['attachments'] as List)
          .map((e) => ReportAttachmentModel.fromJson(e))
          .toList();
    }

    List<ReportStatusHistoryModel> history = [];
    if (reportData['statusHistory'] is List) {
      history = (reportData['statusHistory'] as List)
          .map((e) => ReportStatusHistoryModel.fromJson(e))
          .toList();
    }

    List<ReportEvidenceModel> evidenceList = [];
    if (reportData['evidences'] is List) {
      evidenceList = (reportData['evidences'] as List)
          .map((e) => ReportEvidenceModel.fromJson(e))
          .toList();
    }

    final imageUrl = attachments.isNotEmpty
        ? "${ApiConstants.baseUrl}/${attachments.first.file}"
        : "assets/images/default.jpg";

    return ReportSaveModel(
      reportId: reportData['id'] ?? 0,
      title: reportData['title'] ?? '',
      description: reportData['description'] ?? '',
      location: reportData['location_details'] ?? '',
      date: reportData['date'] ?? '',
      status: reportData['status'] ?? '',
      latitude: (reportData['latitude'] ?? 0.0).toDouble(),
      longitude: (reportData['longitude'] ?? 0.0).toDouble(),
      attachments: attachments,
      imageUrl: imageUrl,
      userId: reportData['user_id'] ?? 0,
      reportNumber: reportData['report_number'] ?? '',
      user: reportData['user'] != null
          ? UserModel.fromJson(reportData['user'])
          : UserModel(id: 0, username: 'Unknown', email: '', phoneNumber: '', type: 0),
      statusHistory: history,
      isSaved: reportData['is_saved'] ?? false,
      evidences: evidenceList,
    );
  }

  /// Konversi ke ReportEntity biasa (seperti `toReport()` sebelumnya)
  ReportEntity toReportEntity() {
    return ReportEntity(
      id: reportId,
      userId: userId,
      reportNumber: reportNumber,
      title: title,
      description: description,
      date: date,
      status: status,
      village: location,
      locationDetails: location,
      latitude: latitude,      
      longitude: longitude,     
      likes: 0,
      attachments: attachments,
      user: user,
      statusHistory: statusHistory,
      evidences: evidences,
      isSaved: isSaved,
    );
  }

  ReportSaveEntity toEntity() {
  return ReportSaveEntity(
    reportId: reportId,
    title: title,
    description: description,
    location: location,
    date: date,
    status: status,
    latitude: latitude,
    longitude: longitude,
    attachments: attachments,
    imageUrl: imageUrl,
    userId: userId,
    reportNumber: reportNumber,
    user: user,
    statusHistory: statusHistory,
    isSaved: isSaved,
    evidences: evidences,
  );
}

}
