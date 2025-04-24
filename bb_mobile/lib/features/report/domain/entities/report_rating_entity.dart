// report_rating_entity.dart
class ReportRating {
  final int id;
  final int reportId;
  final int userId;
  final int rating;
  final String? review;
  final DateTime ratedAt;

  ReportRating({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.rating,
    this.review,
    required this.ratedAt,
  });
}
