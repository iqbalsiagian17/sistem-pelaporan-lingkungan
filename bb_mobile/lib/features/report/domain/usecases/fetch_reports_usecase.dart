import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class FetchReportsUseCase {
  final ReportRepository repository;

  FetchReportsUseCase(this.repository);

  Future<List<ReportEntity>> execute() async {
    return await repository.fetchReports();
  }
}
