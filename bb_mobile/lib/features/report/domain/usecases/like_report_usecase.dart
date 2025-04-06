import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class LikeReportUseCase {
  final ReportRepository repository;

  LikeReportUseCase(this.repository);

  Future<bool> execute(int reportId) {
    return repository.likeReport(reportId);
  }
}
