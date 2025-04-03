import 'package:bb_mobile/core/providers/dio_provider.dart';
import 'package:bb_mobile/features/report/domain/usecases/create_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bb_mobile/features/report/data/datasources/report_remote_datasource.dart';
import 'package:bb_mobile/features/report/data/repositories/report_repository_impl.dart';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';
import 'package:bb_mobile/features/report/domain/usecases/fetch_reports_usecase.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ReportRemoteDataSourceImpl(dio);
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final remote = ref.read(reportRemoteDataSourceProvider);
  return ReportRepositoryImpl(remoteDataSource: remote);
});

final fetchReportsUseCaseProvider = Provider<FetchReportsUseCase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return FetchReportsUseCase(repository);
});

final createReportUseCaseProvider = Provider<CreateReportUseCase>((ref) {
  final repository = ref.read(reportRepositoryProvider);
  return CreateReportUseCase(repository);
});
