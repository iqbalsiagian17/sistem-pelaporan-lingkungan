import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/api.dart'; // ✅ Import Base URL

class UserPasswordService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.authBaseUrl, // ✅ Gunakan base URL dari ApiConstants
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

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
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      return response.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
