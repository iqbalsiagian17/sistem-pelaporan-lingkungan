import 'package:bb_mobile/features/report_save/domain/repositories/report_save_repository.dart';

class SaveReportUseCase {
  final ReportSaveRepository repository;

  SaveReportUseCase(this.repository);

  Future<void> execute(int reportId) async {
    await repository.saveReport(reportId);
  }
}
