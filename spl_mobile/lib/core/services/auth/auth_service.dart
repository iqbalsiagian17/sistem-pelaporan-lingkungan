import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';
import 'package:spl_mobile/core/services/firebase/firebase_token_helper.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  /// 🔐 Login dengan username/email dan password
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _dio.post(
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

      return {"error": "Login gagal: Data tidak lengkap"};
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  /// 🆕 Register user
  Future<Map<String, dynamic>> register(String phone, String username, String email, String password) async {
    try {
      final response = await _dio.post(
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

  /// 🔄 Refresh Token
  Future<bool> refreshToken() async {
    final refreshToken = await globalAuthService.getRefreshToken();
    if (refreshToken == null) {
      print("❌ Tidak ada refresh token. Harus login ulang.");
      await logout();
      return false;
    }

    try {
      final response = await _dio.post(
        "${ApiConstants.authBaseUrl}/refresh-token",
        data: {"refresh_token": refreshToken},
      );

      final newAccessToken = response.data["access_token"];
      final newRefreshToken = response.data["refresh_token"] ?? refreshToken;

      if (newAccessToken != null) {
        await globalAuthService.saveToken(newAccessToken, newRefreshToken);
        print("✅ Token berhasil diperbarui.");
        return true;
      }

      return false;
    } catch (e) {
      print("❌ Gagal refresh token: $e");
      await logout();
      return false;
    }
  }

  /// 🚪 Logout dan hapus data user
  Future<void> logout() async {
    await globalAuthService.clearAuthData();
    print("✅ Logout sukses. Semua data dibersihkan.");
  }

  /// 🔎 Cek status login
  Future<bool> isLoggedIn() async => globalAuthService.isLoggedIn();

  /// 🧠 Handle error
  String _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          return "Permintaan tidak valid.";
        case 401:
          return "Akses tidak sah. Silakan login ulang.";
        case 403:
          return "Tidak diizinkan.";
        case 404:
          return "Sumber daya tidak ditemukan.";
        case 500:
          return "Server error. Coba lagi nanti.";
        default:
          return e.response?.data["message"] ?? "Terjadi kesalahan.";
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return "Timeout koneksi.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server tidak merespons.";
    } else {
      return "Kesalahan jaringan atau sistem.";
    }
  }
}
