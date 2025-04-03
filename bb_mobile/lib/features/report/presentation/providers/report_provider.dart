import 'dart:io';

import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/report/domain/usecases/create_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/usecases/fetch_reports_usecase.dart';
import 'usecase_providers.dart'; // ✅ penting!

final reportProvider = StateNotifierProvider<ReportNotifier, AsyncValue<List<ReportEntity>>>((ref) {
  final fetchUseCase = ref.read(fetchReportsUseCaseProvider);
  final createUseCase = ref.read(createReportUseCaseProvider);
  return ReportNotifier(fetchUseCase, createUseCase);
});


class ReportNotifier extends StateNotifier<AsyncValue<List<ReportEntity>>> {
  final FetchReportsUseCase _fetchReportsUseCase;
  final CreateReportUseCase _createReportUseCase;

  ReportNotifier(
    this._fetchReportsUseCase,
    this._createReportUseCase,
  ) : super(const AsyncLoading()) {
    fetchReports();
  }

  

  Future<void> fetchReports() async {
    try {
    final reports = await _fetchReportsUseCase.execute();
      state = AsyncValue.data(reports);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> createReport({
    required String title,
    required String description,
    required String date,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
  }) async {
    try {
      // Cek user ID
      final userId = await globalAuthService.getUserId();
      final currentReports = state.value ?? [];

      if (userId != null) {
        final hasPending = currentReports.any(
          (r) => r.userId == userId && r.status != 'closed' && r.status != 'rejected',
        );

        if (hasPending) {
          throw Exception("Anda masih memiliki laporan yang belum selesai.");
        }
      }

      // Cek validasi lokasi
      if (isAtLocation == true &&
          (latitude == null || longitude == null || latitude.isEmpty || longitude.isEmpty)) {
        throw Exception("Gagal mengirim laporan: Lokasi tidak tersedia. Aktifkan GPS Anda.");
      }

      final success = await _createReportUseCase.execute(
        title: title,
        description: description,
        date: date,
        locationDetails: locationDetails,
        village: village,
        latitude: latitude,
        longitude: longitude,
        isAtLocation: isAtLocation,
        attachments: attachments,
      );

      if (success) {
        await fetchReports(); // Refresh data
      }

      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow; // ⬅️ Penting agar error tetap dilempar ke UI
    }
  }
}
