import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/data/models/report_attachment_model.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';
import 'package:bb_mobile/features/report/data/models/report_status_history_model.dart';
import 'package:bb_mobile/features/report/data/models/report_evidence_model.dart';
import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';

ReportModel convertSaveEntityToReportModel(ReportSaveEntity save) {
  return ReportModel(
    id: save.reportId,
    userId: save.userId,
    reportNumber: save.reportNumber,
    title: save.title,
    description: save.description,
    date: save.date,
    status: save.status,
    latitude: save.latitude,
    longitude: save.longitude,
    locationDetails: '', // opsional, isi jika ada
    villageId: null, // karena dari ReportSaveEntity hanya ada `location` (nama)
    villageModel: null, // bisa null karena hanya `String location` yang tersedia
    attachments: save.attachments
        .map((e) => ReportAttachmentModel.fromEntity(e))
        .toList(),
    user: UserModel.fromEntity(save.user),
    statusHistory: save.statusHistory
        .map((e) => ReportStatusHistoryModel.fromEntity(e))
        .toList(),
    total_likes: 0, // default
    isSaved: save.isSaved,
    evidences: save.evidences
        .map((e) => ReportEvidenceModel.fromEntity(e))
        .toList(),
    createdAt: '', // atau isi dengan save.createdAt jika tersedia
    updatedAt: '', // atau isi dengan save.updatedAt jika tersedia
  );
}
