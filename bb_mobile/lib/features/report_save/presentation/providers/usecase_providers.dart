import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/report_save/data/datasources/report_save_remote_datasource.dart'as datasource;
import 'package:bb_mobile/features/report_save/data/repositories/report_save_repository_impl.dart'as repo;
import 'package:bb_mobile/features/report_save/domain/repositories/report_save_repository.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/delete_saved_report_usecase.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/fetch_saved_reports_usecase.dart';
import 'package:bb_mobile/features/report_save/domain/usecases/save_report_usecase.dart';

/// ✅ Remote datasource
final reportSaveRemoteDatasourceProvider = Provider<datasource.ReportSaveRemoteDatasource>((ref) {
  return datasource.ReportSaveRemoteDatasourceImpl();
});

/// ✅ Repository
final reportSaveRepositoryProvider = Provider<ReportSaveRepository>((ref) {
  final remote = ref.read(reportSaveRemoteDatasourceProvider);
  return repo.ReportSaveRepositoryImpl(remote);
});

/// ✅ Usecase: Fetch saved reports
final fetchSavedReportsUseCaseProvider = Provider<FetchSavedReportsUseCase>((ref) {
  final repo = ref.read(reportSaveRepositoryProvider);
  return FetchSavedReportsUseCase(repo);
});

/// ✅ Usecase: Save report
final saveReportUseCaseProvider = Provider<SaveReportUseCase>((ref) {
  final repo = ref.read(reportSaveRepositoryProvider);
  return SaveReportUseCase(repo);
});

/// ✅ Usecase: Delete saved report
final deleteSavedReportUseCaseProvider = Provider<DeleteSavedReportUseCase>((ref) {
  final repo = ref.read(reportSaveRepositoryProvider);
  return DeleteSavedReportUseCase(repo);
});
