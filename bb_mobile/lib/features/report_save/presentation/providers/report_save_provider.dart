import 'package:bb_mobile/features/report_save/presentation/providers/usecase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/delete_saved_report_usecase.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/fetch_saved_reports_usecase.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/save_report_usecase.dart';

final reportSaveNotifierProvider = StateNotifierProvider<ReportSaveNotifier, AsyncValue<List<ReportSaveEntity>>>((ref) {
  final fetchUseCase = ref.watch(fetchSavedReportsUseCaseProvider);
  final saveUseCase = ref.watch(saveReportUseCaseProvider);
  final deleteUseCase = ref.watch(deleteSavedReportUseCaseProvider);

  return ReportSaveNotifier(fetchUseCase, saveUseCase, deleteUseCase);
});

class ReportSaveNotifier extends StateNotifier<AsyncValue<List<ReportSaveEntity>>> {
  final FetchSavedReportsUseCase _fetchSavedReports;
  final SaveReportUseCase _saveReport;
  final DeleteSavedReportUseCase _deleteSavedReport;

  ReportSaveNotifier(
    this._fetchSavedReports,
    this._saveReport,
    this._deleteSavedReport,
  ) : super(const AsyncLoading()) {
    fetchSavedReports();
  }

  Future<void> fetchSavedReports() async {
    try {
      final result = await _fetchSavedReports.execute();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveReport(int reportId) async {
    try {
      await _saveReport.execute(reportId);
      await fetchSavedReports();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteSavedReport(int reportId) async {
    try {
      await _deleteSavedReport.execute(reportId);
      await fetchSavedReports();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
