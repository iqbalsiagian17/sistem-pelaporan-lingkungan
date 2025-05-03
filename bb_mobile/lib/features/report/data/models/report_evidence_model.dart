import 'package:bb_mobile/features/report/domain/entities/report_evidence_entity.dart';

class ReportEvidenceModel extends ReportEvidenceEntity {
  final String createdAt;

  ReportEvidenceModel({
    required int id,
    required String file,
    required this.createdAt,
  }) : super(id: id, file: file, createdAt: createdAt);

  factory ReportEvidenceModel.fromJson(Map<String, dynamic> json) {
    return ReportEvidenceModel(
      id: json['id'] ?? 0,
      file: json['file'] ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  factory ReportEvidenceModel.fromEntity(ReportEvidenceEntity entity) {
    return ReportEvidenceModel(
      id: entity.id,
      file: entity.file,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'file': file,
        'createdAt': createdAt,
      };
}
