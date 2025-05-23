import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'dart:io';

abstract class ReportRepository {
  Future<List<ReportEntity>> fetchReports();
  Future<ReportEntity?> getReportById(String reportId);
  Future<ReportEntity?> createReport({ // ⬅️ Diubah dari bool → ReportEntity?
    required String title,
    required String description,
    required String date,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
    required String status, 
  });

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
  });
  Future<bool> deleteReport(String reportId);
  Future<bool> likeReport(int reportId);
  Future<bool> unlikeReport(int reportId);
  Future<bool> isLiked(int reportId);
  Future<int> getLikeCount(int reportId);

  Future<bool> submitRating({
      required int reportId,
      required int rating,
      String? review,
    });

    Future<Map<String, dynamic>?> getRating(int reportId);
}
