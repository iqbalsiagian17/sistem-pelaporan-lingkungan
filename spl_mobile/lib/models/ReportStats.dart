class ReportStats {
  final int sent;
  final int completed;
  final int saved;

  ReportStats({required this.sent, required this.completed, required this.saved});

  factory ReportStats.fromJson(Map<String, dynamic> json) {
    return ReportStats(
      sent: json['sent'],
      completed: json['completed'],
      saved: json['saved'],
    );
  }
}
