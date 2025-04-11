import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';

abstract class ReportRemoteDataSource {
  Future<List<ReportModel>> fetchReports();
  Future<ReportEntity?> getReportById(String reportId);
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
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ReportModel>> fetchReports() async {
    try {
      final response = await dio.get('${ApiConstants.userReportUrl}/all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('reports')) {
          final reportList = data['reports'] as List;
          return reportList.map((e) => ReportModel.fromJson(e)).toList();
        } else {
          throw Exception("Format data tidak sesuai (tidak ada key 'reports')");
        }
      } else {
        throw Exception(" Gagal mengambil data laporan. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception(" Terjadi kesalahan saat mengambil laporan: $e");
    }
  }

  @override
  Future<ReportEntity?> getReportById(String reportId) async {
    try {
      final response = await dio.get('${ApiConstants.userReportUrl}/$reportId');

      if (response.statusCode == 200 && response.data['report'] != null) {
        return ReportModel.fromJson(response.data['report']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
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
}) async {
  try {
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "date": date.split("T")[0],
      "location_details": locationDetails?.trim() ?? "Tidak ada detail lokasi",
      if (isAtLocation == false && village != null) "village": village,
      if (isAtLocation == true && latitude != null) "latitude": latitude,
      if (isAtLocation == true && longitude != null) "longitude": longitude,
      "is_at_location": isAtLocation.toString(),
    });

    if (attachments != null && attachments.isNotEmpty) {
      for (var file in attachments) {
        final fileName = file.path.split('/').last;
        formData.files.add(MapEntry(
          "attachments",
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType("image", "jpeg"),
          ),
        ));
      }
    }

    final response = await dio.post(
      '${ApiConstants.userReportUrl}/create',
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    if (response.statusCode == 201 && response.data['report'] != null) {
      return ReportModel.fromJson(response.data['report']);
    }

    return null;
  } on DioException catch (e) {
    throw Exception("Gagal membuat laporan: ${e.response?.data}");
  }
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
  try {
    final formData = FormData.fromMap({
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (locationDetails != null) "location_details": locationDetails,
      if (isAtLocation == false && village != null) "village": village,
      if (isAtLocation == true && latitude != null) "latitude": latitude,
      if (isAtLocation == true && longitude != null) "longitude": longitude,
      if (isAtLocation != null) "is_at_location": isAtLocation.toString(),
      if (deleteAttachmentIds != null && deleteAttachmentIds.isNotEmpty)
        "delete_attachments": deleteAttachmentIds,
    });

    if (attachments != null && attachments.isNotEmpty) {
      for (var file in attachments) {
        final fileName = file.path.split('/').last;
        formData.files.add(MapEntry(
          "attachments",
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType("image", "jpeg"),
          ),
        ));
      }
    }

    final response = await dio.put(
      '${ApiConstants.userReportUrl}/$reportId',
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    if (response.statusCode == 200 && response.data['report'] != null) {
      return ReportModel.fromJson(response.data['report']);
    }

    return null;
  } on DioException catch (e) {
    throw Exception("Gagal memperbarui laporan: ${e.response?.data}");
  }
}


  @override
  Future<bool> deleteReport(String reportId) async {
    try {
      final response = await dio.delete('${ApiConstants.userReportUrl}/$reportId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(" Gagal menghapus laporan: ${e.response?.data}");
    }
  }

    @override
  Future<bool> likeReport(int reportId) async {
    try {
      final response = await dio.post(
        "${ApiConstants.userReportLike}/$reportId/like",
      );
      return response.statusCode == 201;
    } catch (e) {
      print(" [likeReport] Error: $e");
      return false;
    }
  }

  @override
  Future<bool> unlikeReport(int reportId) async {
    try {
      final response = await dio.delete(
        "${ApiConstants.userReportLike}/$reportId/unlike",
      );
      return response.statusCode == 200;
    } catch (e) {
      print(" [unlikeReport] Error: $e");
      return false;
    }
  }

  @override
  Future<bool> isLiked(int reportId) async {
    try {
      final response = await dio.get(
        "${ApiConstants.userReportLike}/$reportId/status",
      );
      return response.statusCode == 200 && response.data['isLiked'] == true;
    } catch (e) {
      print(" [isLiked] Error: $e");
      return false;
    }
  }

  @override
  Future<int> getLikeCount(int reportId) async {
    try {
      final response = await dio.get(
        "${ApiConstants.userReportLike}/$reportId",
      );
      if (response.statusCode == 200) {
        return response.data['report']['total_likes'] ?? 0;
      }
      return 0;
    } catch (e) {
      print(" [getLikeCount] Error: $e");
      return 0;
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final status = e.response!.statusCode;
      switch (status) {
        case 400: return "Permintaan tidak valid.";
        case 401: return "Akses tidak sah.";
        case 403: return "Tidak diizinkan.";
        case 404: return "Laporan tidak ditemukan.";
        case 500: return "Terjadi kesalahan pada server.";
        default: return e.response?.data["message"] ?? "Terjadi kesalahan.";
      }
    } else {
      return "Kesalahan jaringan atau sistem.";
    }
  }
}
