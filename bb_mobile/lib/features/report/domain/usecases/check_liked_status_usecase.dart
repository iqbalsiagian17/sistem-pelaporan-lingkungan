import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class CheckLikedStatusUseCase {
  final ReportRepository repository;

  CheckLikedStatusUseCase(this.repository);

  Future<bool> execute(int reportId) {
    return repository.isLiked(reportId);
  }
}
