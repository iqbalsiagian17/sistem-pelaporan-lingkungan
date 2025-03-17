import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';

class ReportLikeService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.userReportLike,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// 🔹 Mengecek apakah laporan sudah di-like oleh pengguna
  Future<bool> isLiked(int reportId, String token) async {
    try {
      final response = await _dio.get(
        "/$reportId/status",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200 && response.data['isLiked'] == true;
    } catch (e) {
      print("❌ [isLiked] Error: $e");
      return false;
    }
  }

  /// 🔹 Menyukai laporan
  Future<bool> likeReport(int reportId, String token) async {
    try {
      final response = await _dio.post(
        "/$reportId/like",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("❌ [likeReport] Error: $e");
      return false;
    }
  }

  /// 🔹 Menghapus like dari laporan
  Future<bool> unlikeReport(int reportId, String token) async {
    try {
      final response = await _dio.delete(
        "/$reportId/unlike",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ [unlikeReport] Error: $e");
      return false;
    }
  }
}
