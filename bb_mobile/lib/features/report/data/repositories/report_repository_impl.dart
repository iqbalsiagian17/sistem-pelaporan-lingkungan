import 'dart:io';
import 'package:bb_mobile/features/report/data/datasources/report_remote_datasource.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReportEntity>> fetchReports() async {
    return await remoteDataSource.fetchReports();
  }

  @override
  Future<ReportEntity?> getReportById(String reportId) async {
    return await remoteDataSource.getReportById(reportId);
  }

  @override
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
    required String status, 
  }) async {
    return await remoteDataSource.createReport(
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
  }

  @override
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
  return await remoteDataSource.updateReport(
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
}



  @override
  Future<bool> deleteReport(String reportId) async {
    return await remoteDataSource.deleteReport(reportId);
  }

  // 🔽 Tambahan untuk fitur likes
  @override
  Future<bool> likeReport(int reportId) async {
    return await remoteDataSource.likeReport(reportId);
  }

  @override
  Future<bool> unlikeReport(int reportId) async {
    return await remoteDataSource.unlikeReport(reportId);
  }

  @override
  Future<bool> isLiked(int reportId) async {
    return await remoteDataSource.isLiked(reportId);
  }

  @override
  Future<int> getLikeCount(int reportId) async {
    return await remoteDataSource.getLikeCount(reportId);
  }

  @override
  Future<bool> submitRating({
    required int reportId,
    required int rating,
    String? review,
  }) async {
    return await remoteDataSource.submitRating(
      reportId: reportId,
      rating: rating,
      review: review,
    );
  }

  @override
  Future<Map<String, dynamic>?> getRating(int reportId) async {
    return await remoteDataSource.getRating(reportId);
  }
}
