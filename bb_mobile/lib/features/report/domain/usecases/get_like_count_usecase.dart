import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class GetLikeCountUseCase {
  final ReportRepository repository;

  GetLikeCountUseCase(this.repository);

  Future<int> execute(int reportId) {
    return repository.getLikeCount(reportId);
  }
}
