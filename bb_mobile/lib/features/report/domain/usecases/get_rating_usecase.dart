import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class GetRatingUsecase {
  final ReportRepository repository;

  GetRatingUsecase(this.repository);

  Future<Map<String, dynamic>?> call(int reportId) {
    return repository.getRating(reportId);
  }
}
