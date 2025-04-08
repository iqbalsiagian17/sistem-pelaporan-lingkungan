import 'package:bb_mobile/features/report/domain/entities/report_attachment_entity.dart';

class ReportAttachmentModel extends ReportAttachmentEntity {
  ReportAttachmentModel({
    required int id,
    required int reportId,
    required String file,
  }) : super(
          id: id,
          reportId: reportId,
          file: file,
        );

  factory ReportAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ReportAttachmentModel(
      id: json['id'] ?? 0,
      reportId: json['report_id'] ?? 0,
      file: json['file'] ?? '',
    );
  }

  factory ReportAttachmentModel.fromEntity(ReportAttachmentEntity entity) {
    return ReportAttachmentModel(
      id: entity.id,
      reportId: entity.reportId,
      file: entity.file,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'report_id': reportId,
        'file': file,
      };
}
