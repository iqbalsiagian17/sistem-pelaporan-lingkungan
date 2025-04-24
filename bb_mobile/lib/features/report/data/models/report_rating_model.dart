// report_rating_model.dart
class ReportRatingModel {
  final int id;
  final int reportId;
  final int userId;
  final int rating;
  final String? review;
  final DateTime ratedAt;

  ReportRatingModel({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.rating,
    this.review,
    required this.ratedAt,
  });

  factory ReportRatingModel.fromJson(Map<String, dynamic> json) {
    return ReportRatingModel(
      id: json['id'],
      reportId: json['report_id'],
      userId: json['user_id'],
      rating: json['rating'],
      review: json['review'],
      ratedAt: DateTime.parse(json['rated_at']),
    );
  }
}
