import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class UnlikeReportUseCase {
  final ReportRepository repository;

  UnlikeReportUseCase(this.repository);

  Future<bool> execute(int reportId) {
    return repository.unlikeReport(reportId);
  }
}
