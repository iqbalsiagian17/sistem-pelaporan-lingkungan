import 'package:bb_mobile/features/report_save/data/datasources/report_save_remote_datasource.dart';
import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';
import 'package:bb_mobile/features/report_save/domain/repositories/report_save_repository.dart';

class ReportSaveRepositoryImpl implements ReportSaveRepository {
  final ReportSaveRemoteDatasource remoteDatasource;

  ReportSaveRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<ReportSaveEntity>> fetchSavedReports() async {
    final result = await remoteDatasource.fetchSavedReports();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> saveReport(int reportId) {
    return remoteDatasource.saveReport(reportId);
  }

  @override
  Future<void> deleteSavedReport(int reportId) {
    return remoteDatasource.deleteSavedReport(reportId);
  }
}
