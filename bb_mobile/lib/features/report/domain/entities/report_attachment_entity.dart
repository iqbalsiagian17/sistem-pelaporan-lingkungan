class ReportAttachmentEntity {
  final int id;
  final int reportId;
  final String file;

  ReportAttachmentEntity({
    required this.id,
    required this.reportId,
    required this.file,
  });

  factory ReportAttachmentEntity.fromJson(Map<String, dynamic> json) {
    return ReportAttachmentEntity(
      id: json['id'],
      reportId: json['report_id'],
      file: json['file'],
    );
  }
}