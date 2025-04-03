import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class GetReportByIdUseCase {
  final ReportRepository repository;

  GetReportByIdUseCase(this.repository);

  Future<ReportEntity?> execute(String reportId) {
    return repository.getReportById(reportId);
  }
}
