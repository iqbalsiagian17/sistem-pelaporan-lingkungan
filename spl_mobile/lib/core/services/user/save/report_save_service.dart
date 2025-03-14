import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import '../../../../models/ReportSave.dart';

class ReportSaveService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "${ApiConstants.baseUrl}/api/user/saved-reports",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<ReportSave>> fetchSavedReports(String token) async {
    try {
      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['savedReports'];
        return data.map((json) => ReportSave.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil laporan yang disimpan.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  Future<void> saveReport(int reportId, String token) async {
    try {
      await _dio.post(
        "/",
        data: {"report_id": reportId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menyimpan laporan: $e");
    }
  }

  Future<void> deleteSavedReport(int reportId, String token) async {
    try {
      await _dio.delete(
        "/$reportId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menghapus laporan: $e");
    }
  }
}
