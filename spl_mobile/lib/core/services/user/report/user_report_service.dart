  import 'dart:io';
  import 'package:dio/dio.dart';
  import 'package:http_parser/http_parser.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';
  import '../../../constants/api.dart';
  import '../../../../models/Report.dart';

  class ReportService {
    
  final Dio _dio = DioClient.instance;
    // ✅ Ambil Semua Laporan
  Future<List<Report>> getAllReports() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.userReportUrl}/all',
      );
        if (response.statusCode == 200) {
          List<dynamic> data = response.data['reports'];

          return data.map((report) => Report.fromJson(report)).toList();
        } else {
          throw Exception("❌ Gagal mengambil data laporan. Status: ${response.statusCode}");
        }
      } catch (e) {
        throw Exception("❌ Terjadi kesalahan saat mengambil laporan: $e");
      }
    }

    // ✅ Ambil Laporan Berdasarkan ID
    Future<Report?> getReportById(String reportId) async {
    try {
      final response = await _dio.get('/reports/$reportId');
      if (response.statusCode == 200) {
        final report = Report.fromJson(response.data['report']);
        return report;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


    // ✅ Buat Laporan Baru
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
            await MultipartFile.fromFile(file.path, filename: fileName, contentType: MediaType("image", "jpeg")),
          ));
        }
      }

      final response = await _dio.post(
        '${ApiConstants.userReportUrl}/create',
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      return response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception("Gagal membuat laporan: ${e.response?.data}");
    }
  }


    // ✅ Hapus Laporan
  Future<bool> deleteReport(String reportId) async {
    try {
      final response = await _dio.delete('${ApiConstants.userReportUrl}/$reportId');

      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Report>> getUserReports() async {
    try {
      final response = await _dio.get('${ApiConstants.userReportUrl}/all');

      if (response.statusCode == 200) {
        int? userId = await globalAuthService.getUserId();

        List<dynamic> data = response.data['reports'];
        return data
            .map((r) => Report.fromJson(r))
            .where((r) => r.userId == userId)
            .toList();
      } else {
        throw Exception("❌ Gagal mengambil laporan user. Status: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  }
