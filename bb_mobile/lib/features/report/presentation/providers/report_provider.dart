import 'dart:io';
import 'package:bb_mobile/features/report/domain/usecases/get_rating_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/submit_rating_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/update_report_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/usecases/create_report_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/delete_report_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/fetch_reports_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/like_report_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/unlike_report_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/check_liked_status_usecase.dart';
import 'package:bb_mobile/features/report/domain/usecases/get_like_count_usecase.dart';
import 'usecase_providers.dart';

final reportProvider = StateNotifierProvider<ReportNotifier, AsyncValue<List<ReportEntity>>>((ref) {
  final fetchUseCase = ref.read(fetchReportsUseCaseProvider);
  final createUseCase = ref.read(createReportUseCaseProvider);
  final updateUseCase = ref.read(updateReportUseCaseProvider);
  final deleteUseCase = ref.read(deleteReportUseCaseProvider);
  final likeUseCase = ref.read(likeReportUseCaseProvider);
  final unlikeUseCase = ref.read(unlikeReportUseCaseProvider);
  final checkLikedUseCase = ref.read(checkLikedStatusUseCaseProvider);
  final likeCountUseCase = ref.read(getLikeCountUseCaseProvider);
  final submitRatingUseCase = ref.read(submitRatingUseCaseProvider);
  final getRatingUseCase = ref.read(getRatingUseCaseProvider);
  

  return ReportNotifier(
    fetchUseCase,
    createUseCase,
    updateUseCase,
    deleteUseCase,
    likeUseCase,
    unlikeUseCase,
    checkLikedUseCase,
    likeCountUseCase,
    submitRatingUseCase,
    getRatingUseCase,
  );
});

class ReportNotifier extends StateNotifier<AsyncValue<List<ReportEntity>>> {
  final FetchReportsUseCase _fetchReportsUseCase;
  final CreateReportUseCase _createReportUseCase;
  final UpdateReportUseCase _updateReportUseCase;
  final DeleteReportUseCase _deleteReportUseCase;
  final LikeReportUseCase _likeReportUseCase;
  final UnlikeReportUseCase _unlikeReportUseCase;
  final CheckLikedStatusUseCase _checkLikedStatusUseCase;
  final GetLikeCountUseCase _getLikeCountUseCase;
  final SubmitRatingUsecase _submitRatingUseCase;
  final GetRatingUsecase _getRatingUseCase;

  final _likedReportIds = <int>{};
  final _likeCounts = <int, int>{};

  Set<int> get likedReportIds => _likedReportIds;
  Map<int, int> get likeCounts => _likeCounts;

  ReportNotifier(
    this._fetchReportsUseCase,
    this._createReportUseCase,
    this._updateReportUseCase,
    this._deleteReportUseCase,
    this._likeReportUseCase,
    this._unlikeReportUseCase,
    this._checkLikedStatusUseCase,
    this._getLikeCountUseCase,
    this._submitRatingUseCase,
    this._getRatingUseCase,
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

  Future<ReportEntity?> createReport({
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
    final userId = await globalAuthService.getUserId();
    final currentReports = state.value ?? [];

    bool hasPending = false;
    if (userId != null) {
      hasPending = currentReports.any(
        (r) => r.userId == userId &&
            r.status != 'closed' &&
            r.status != 'rejected' &&
            r.status != 'canceled',
      );
    }

    final status = hasPending ? 'draft' : 'pending';

    if (isAtLocation == true &&
        (latitude == null || longitude == null || latitude.isEmpty || longitude.isEmpty)) {
      throw Exception("Gagal mengirim laporan: Lokasi tidak tersedia. Aktifkan GPS Anda.");
    }

    final newReport = await _createReportUseCase.execute(
      title: title,
      description: description,
      date: date,
      locationDetails: locationDetails,
      village: village,
      latitude: latitude,
      longitude: longitude,
      isAtLocation: isAtLocation,
      attachments: attachments,
      status: status, // ✅ Kirim status ke backend
    );

    if (newReport != null) {
      await fetchReports();
      return newReport;
    }

    return null;
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    rethrow;
  }
}



  Future<ReportEntity?> updateReport({
    required String reportId,
    String? title,
    String? description,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
    List<int>? deleteAttachmentIds,
  }) async {
    try {
      final updatedReport = await _updateReportUseCase.execute(
        reportId: reportId,
        title: title,
        description: description,
        locationDetails: locationDetails,
        village: village,
        latitude: latitude,
        longitude: longitude,
        isAtLocation: isAtLocation,
        attachments: attachments,
        deleteAttachmentIds: deleteAttachmentIds,
      );

      if (updatedReport != null) {
        await fetchReports();
      }

      return updatedReport;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }


  Future<bool> deleteReport(String reportId) async {
    try {
      final success = await _deleteReportUseCase.execute(reportId);
      if (success) {
        await fetchReports();
      }
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> likeReport(int reportId) async {
    try {
      final success = await _likeReportUseCase.execute(reportId);
      if (success) {
        _likedReportIds.add(reportId);
        await fetchLikeCount(reportId);
        state = AsyncValue.data([...state.value ?? []]);
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> unlikeReport(int reportId) async {
    try {
      final success = await _unlikeReportUseCase.execute(reportId);
      if (success) {
        _likedReportIds.remove(reportId);
        await fetchLikeCount(reportId);
        state = AsyncValue.data([...state.value ?? []]);
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchLikeStatus(int reportId) async {
    try {
      final isLiked = await _checkLikedStatusUseCase.execute(reportId);
      if (isLiked) {
        _likedReportIds.add(reportId);
      } else {
        _likedReportIds.remove(reportId);
      }
      state = AsyncValue.data([...state.value ?? []]);
    } catch (_) {}
  }

  Future<void> fetchLikeCount(int reportId) async {
    try {
      final count = await _getLikeCountUseCase.execute(reportId);
      _likeCounts[reportId] = count;
      state = AsyncValue.data([...state.value ?? []]);
    } catch (_) {}
  }

  Future<ReportEntity?> fetchReportById(int id) async {
    try {
      final reports = state.value ?? [];
      return reports.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception("Laporan tidak ditemukan"),
      );
    } catch (_) {
      try {
        await fetchReports();
        final updatedReports = state.value ?? [];
        return updatedReports.firstWhere(
          (r) => r.id == id,
          orElse: () => throw Exception("Laporan tidak ditemukan"),
        );
      } catch (_) {
        return null;
      }
    }
  }

  Future<bool> submitRating({
    required int reportId,
    required int rating,
    String? review,
  }) async {
    try {
      final result = await _submitRatingUseCase.call(
        reportId: reportId,
        rating: rating,
        review: review,
      );
      await fetchReports();
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getRating(int reportId) async {
    try {
      return await _getRatingUseCase.call(reportId);
    } catch (_) {
      return null;
    }
  }


}
