import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/api.dart'; // ✅ Import Base URL

class UserProfileService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.userProfileBaseUrl, // ✅ Gunakan base URL dari ApiConstants
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // ✅ Ambil informasi user dari backend
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } catch (e) {
      return {"error": "Gagal mengambil data pengguna: ${e.toString()}"};
    }
  }

  // ✅ Update informasi pengguna
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.put(
        "/update",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } catch (e) {
      return {"error": "Gagal memperbarui profil: ${e.toString()}"};
    }
  }

  // ✅ Ubah password
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.put(
        "/change-password",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } catch (e) {
      return {"error": "Gagal mengubah password: ${e.toString()}"};
    }
  }
}