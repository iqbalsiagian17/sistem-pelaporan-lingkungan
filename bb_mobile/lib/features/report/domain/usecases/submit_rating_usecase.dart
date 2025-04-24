import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class SubmitRatingUsecase {
  final ReportRepository repository;

  SubmitRatingUsecase(this.repository);

  Future<bool> call({
    required int reportId,
    required int rating,
    String? review,
  }) {
    return repository.submitRating(
      reportId: reportId,
      rating: rating,
      review: review,
    );
  }
}
