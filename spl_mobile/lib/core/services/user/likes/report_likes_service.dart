import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';

class ReportLikeService {
  final Dio _dio = DioClient.instance;

  /// 🔹 Mengecek apakah laporan sudah di-like oleh pengguna
  Future<bool> isLiked(int reportId) async {
    try {
      final response = await _dio.get(
        "${ApiConstants.userReportLike}/$reportId/status",
      );
      return response.statusCode == 200 && response.data['isLiked'] == true;
    } on DioException catch (e) {
      print("❌ [isLiked] DioException: ${e.response?.data}");
      return false;
    } catch (e) {
      print("❌ [isLiked] Unknown Error: $e");
      return false;
    }
  }

  /// 🔹 Mengambil jumlah likes dari laporan
  Future<int> getLikeCount(int reportId) async {
    try {
      final response = await _dio.get(
        "${ApiConstants.userReportLike}/$reportId",
      );

      if (response.statusCode == 200) {
        return response.data['report']['likes'] ?? 0;
      }
      return 0;
    } catch (e) {
      print("❌ [getLikeCount] Error: $e");
      return 0;
    }
  }

  /// 🔹 Menyukai laporan
  Future<bool> likeReport(int reportId) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.userReportLike}/$reportId/like",
      );

      return response.statusCode == 201;
    } catch (e) {
      print("❌ [likeReport] Error: $e");
      return false;
    }
  }

  /// 🔹 Menghapus like dari laporan
  Future<bool> unlikeReport(int reportId) async {
    try {
      final response = await _dio.delete(
        "${ApiConstants.userReportLike}/$reportId/unlike",
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ [unlikeReport] Error: $e");
      return false;
    }
  }
}
