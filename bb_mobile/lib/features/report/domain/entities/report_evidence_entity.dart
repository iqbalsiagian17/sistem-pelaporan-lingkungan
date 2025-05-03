class ReportEvidenceEntity {
  final int id;
  final String file;
  final String createdAt; // ➕ Tambahan

  ReportEvidenceEntity({
    required this.id,
    required this.file,
    required this.createdAt,
  });

  factory ReportEvidenceEntity.fromJson(Map<String, dynamic> json) {
    return ReportEvidenceEntity(
      id: json['id'],
      file: json['file'],
      createdAt: json['createdAt'] ?? '', // Pastikan tidak null
    );
  }
}
