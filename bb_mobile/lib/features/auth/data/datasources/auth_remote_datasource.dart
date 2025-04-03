import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_token_helper.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String identifier, String password);
  Future<Map<String, dynamic>> register(String phone, String username, String email, String password);
  Future<bool> refreshToken();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/login",
        data: {
          "identifier": identifier,
          "password": password,
          "client": "flutter",
        },
      );

      final data = response.data;
      final user = data["user"];
      final token = data["token"];
      final refreshToken = data["refresh_token"];

      if (user != null && token != null && refreshToken != null) {
        await globalAuthService.saveToken(token, refreshToken);
        await globalAuthService.saveUserInfo(user);
        await saveFcmTokenToBackend(user["id"]);
        return data;
      }
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  @override
  Future<Map<String, dynamic>> register(String phone, String username, String email, String password) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/register",
        data: {
          "phone_number": phone,
          "username": username,
          "email": email,
          "password": password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  @override
  Future<bool> refreshToken() async {
    final refreshToken = await globalAuthService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      // ⚠️ Jangan pake interceptor token di sini!
      final bareDio = Dio(); // tanpa interceptor
      final response = await bareDio.post(
        "${ApiConstants.authBaseUrl}/refresh-token",
        data: {"refresh_token": refreshToken},
      );

      final newAccessToken = response.data["access_token"];
      final newRefreshToken = response.data["refresh_token"] ?? refreshToken;

      await globalAuthService.saveToken(newAccessToken, newRefreshToken);
      return true;
    } catch (_) {
      await globalAuthService.clearAuthData();
      return false;
    }
  }


  @override
  Future<void> logout() async {
    await globalAuthService.clearAuthData();
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final status = e.response!.statusCode;
      switch (status) {
        case 400: return "Permintaan tidak valid.";
        case 401: return "Akses tidak sah.";
        case 403: return "Tidak diizinkan.";
        case 404: return "Tidak ditemukan.";
        case 500: return "Server error.";
        default: return e.response?.data["message"] ?? "Terjadi kesalahan.";
      }
    } else {
      return "Kesalahan jaringan atau sistem.";
    }
  }
}
