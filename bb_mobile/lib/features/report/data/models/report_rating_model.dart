class ReportRatingModel {
  final int id;
  final int reportId;
  final int userId;
  final int rating;
  final String? review;
  final int round;
  final bool isLatest;

  ReportRatingModel({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.rating,
    this.review,
    required this.round,
    required this.isLatest,
  });

  factory ReportRatingModel.fromJson(Map<String, dynamic> json) {
    return ReportRatingModel(
      id: json['id'],
      reportId: json['report_id'],
      userId: json['user_id'],
      rating: json['rating'],
      review: json['review'],
      round: json['round'],
      isLatest: json['is_latest'],
    );
  }
}
