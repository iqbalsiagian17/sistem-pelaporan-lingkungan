import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';
import 'package:bb_mobile/features/report_save/domain/repositories/report_save_repository.dart';

class FetchSavedReportsUseCase {
  final ReportSaveRepository repository;

  FetchSavedReportsUseCase(this.repository);

  Future<List<ReportSaveEntity>> execute() async {
    return await repository.fetchSavedReports();
  }
}
