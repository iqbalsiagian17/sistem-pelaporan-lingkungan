
import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';

abstract class ReportSaveRepository {
  Future<List<ReportSaveEntity>> fetchSavedReports();
  Future<void> saveReport(int reportId);
  Future<void> deleteSavedReport(int reportId);
}
