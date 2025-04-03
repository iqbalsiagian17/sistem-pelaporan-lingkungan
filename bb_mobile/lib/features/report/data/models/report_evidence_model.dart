import 'package:bb_mobile/features/report/domain/entities/report_evidence_entity.dart';

class ReportEvidenceModel extends ReportEvidenceEntity {
  ReportEvidenceModel({
    required int id,
    required String file,
  }) : super(id: id, file: file);

  factory ReportEvidenceModel.fromJson(Map<String, dynamic> json) {
    return ReportEvidenceModel(
      id: json['id'] ?? 0,
      file: json['file'] ?? '',
    );
  }

  /// ✅ Tambahkan ini
  factory ReportEvidenceModel.fromEntity(ReportEvidenceEntity entity) {
    return ReportEvidenceModel(
      id: entity.id,
      file: entity.file,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'file': file,
      };
}
