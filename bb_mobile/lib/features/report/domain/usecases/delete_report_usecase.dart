import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class DeleteReportUseCase {
  final ReportRepository repository;

  DeleteReportUseCase(this.repository);

  Future<bool> execute(String reportId) {
    return repository.deleteReport(reportId);
  }
}
