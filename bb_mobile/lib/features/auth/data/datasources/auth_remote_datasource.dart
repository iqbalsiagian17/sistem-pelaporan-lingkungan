import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_token_helper.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String identifier, String password);
  Future<Map<String, dynamic>> register(String phone, String username, String email, String password);
  Future<Map<String, dynamic>> verifyEmailOtp(String email, String code);
  Future<Map<String, dynamic>> resendOtp(String email);
  Future<bool> refreshToken();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

@override
Future<Map<String, dynamic>> login(String identifier, String password) async {
  print("🔐 Memulai proses login...");
  print("📨 Mengirim data: identifier = $identifier, password = ${'*' * password.length}");

  try {
    final response = await dio.post(
      "${ApiConstants.authBaseUrl}/login",
      data: {
        "identifier": identifier,
        "password": password,
        "client": "flutter",
      },
    );

    print("✅ Login response diterima: ${response.statusCode}");

    final data = response.data;
    print("📦 Response data: $data");

    final user = data["user"];
    final token = data["token"];
    final refreshToken = data["refresh_token"];

    if (user != null && token != null && refreshToken != null) {
      print("🔐 Menyimpan token...");
      await globalAuthService.saveToken(token, refreshToken);
      print("✅ Token berhasil disimpan");

      print("👤 Menyimpan data pengguna...");
      await globalAuthService.saveUserInfo(user);
      print("✅ Data pengguna berhasil disimpan");

      print("📲 Mengirim token FCM ke backend...");
      await saveFcmTokenToBackend(user["id"]);
      print("✅ Token FCM dikirim");

      return data;
    }

    print("⚠️ Login berhasil, tapi data user/token tidak lengkap.");
    return response.data;
  } on DioException catch (e) {
    final errorMsg = _handleDioError(e);
    print("❌ Login gagal: $errorMsg");
    return {"error": errorMsg};
  } catch (e) {
    print("❌ Terjadi error tak terduga: $e");
    return {"error": "Terjadi kesalahan tidak terduga."};
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

  @override
  Future<Map<String, dynamic>> verifyEmailOtp(String email, String code) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/verify-email-otp",
        data: {
          "email": email,
          "code": code,
        },
      );
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  @override
  Future<Map<String, dynamic>> resendOtp(String email) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/resend-otp",
        data: {
          "email": email,
        },
      );
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
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
