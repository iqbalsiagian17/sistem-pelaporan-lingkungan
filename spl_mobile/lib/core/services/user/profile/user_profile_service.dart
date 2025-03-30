import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/constants/api.dart';

class UserProfileService {
  final Dio _dio = DioClient.instance;

  /// ✅ Ambil profil user
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get(
        "${ApiConstants.userProfileBaseUrl}/",
      );
      return response.data;
    } on DioException catch (e) {
      return {
        "error": e.response?.data["error"] ?? "Gagal mengambil data pengguna: ${e.message}"
      };
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  /// ✅ Update profil
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${ApiConstants.userProfileBaseUrl}/update",
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      return {
        "error": e.response?.data["error"] ?? "Gagal memperbarui profil: ${e.message}"
      };
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  /// ✅ Ganti password
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _dio.put(
        "${ApiConstants.userProfileBaseUrl}/change-password",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
      );
      return response.data;
    } on DioException catch (e) {
      return {
        "error": e.response?.data["error"] ?? "Gagal mengubah password: ${e.message}"
      };
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }
}
