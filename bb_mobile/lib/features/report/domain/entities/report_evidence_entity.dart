class ReportEvidenceEntity {
  final int id;
  final String file;

  ReportEvidenceEntity({
    required this.id,
    required this.file,
  });

  factory ReportEvidenceEntity.fromJson(Map<String, dynamic> json) {
    return ReportEvidenceEntity(
      id: json['id'],
      file: json['file'],
    );
  }
}
