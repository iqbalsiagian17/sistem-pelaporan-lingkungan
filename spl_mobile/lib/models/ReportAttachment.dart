class ReportAttachment {
  final int id;
  final int reportId;
  final String file;

  ReportAttachment({
    required this.id,
    required this.reportId,
    required this.file,
  });

  factory ReportAttachment.fromJson(Map<String, dynamic> json) {
    return ReportAttachment(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0, // ✅ Tangani null
      reportId: json['report_id'] is int ? json['report_id'] : int.tryParse(json['report_id'].toString()) ?? 0, // ✅ Tangani null
      file: json['file'] ?? '', // ✅ Pastikan selalu ada nilai
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "report_id": reportId,
      "file": file,
    };
  }
}
