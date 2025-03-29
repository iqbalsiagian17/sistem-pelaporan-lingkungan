class ReportEvidence {
  final int id;
  final String file;

  ReportEvidence({
    required this.id,
    required this.file,
  });

  factory ReportEvidence.fromJson(Map<String, dynamic> json) {
    return ReportEvidence(
      id: json['id'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'file': file,
      };
}
