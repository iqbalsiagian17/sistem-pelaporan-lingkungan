import 'package:bb_mobile/features/profile/domain/entities/report_stats_entity.dart';

class ReportStatsModel extends ReportStatsEntity {
  const ReportStatsModel({
    required super.sent,
    required super.completed,
    required super.saved,
  });

  factory ReportStatsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatsModel(
      sent: json['sent'] ?? 0,
      completed: json['completed'] ?? 0,
      saved: json['saved'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sent': sent,
      'completed': completed,
      'saved': saved,
    };
  }
}
