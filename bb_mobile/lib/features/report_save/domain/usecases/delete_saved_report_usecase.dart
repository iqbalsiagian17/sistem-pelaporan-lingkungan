import 'package:bb_mobile/features/report_save/domain/repositories/report_save_repository.dart';

class DeleteSavedReportUseCase {
  final ReportSaveRepository repository;

  DeleteSavedReportUseCase(this.repository);

  Future<void> execute(int reportId) async {
    await repository.deleteSavedReport(reportId);
  }
}
