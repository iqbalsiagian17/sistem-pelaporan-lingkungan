import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_token_helper.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String identifier, String password);
  Future<Map<String, dynamic>> register(String phone, String username, String email, String password);
  Future<Map<String, dynamic>> verifyEmailOtp(String email, String code);
  Future<Map<String, dynamic>> resendOtp(String email);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> verifyForgotOtp(String email, String code);
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword);
  Future<Map<String, dynamic>> resendForgotOtp(String email);

  Future<bool> refreshToken();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

@override
Future<Map<String, dynamic>> login(String identifier, String password) async {
  print("Memulai proses login...");
  print("Mengirim data: identifier = $identifier, password = ${'*' * password.length}");

  try {
    final response = await dio.post(
      "${ApiConstants.authBaseUrl}/login",
      data: {
        "identifier": identifier,
        "password": password,
        "client": "flutter",
      },
    );

    print("Login response diterima: ${response.statusCode}");

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
    throw _handleDioError(e); 
  } catch (e) {
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

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/forgot-password",
        data: { "email": email },
      );
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

@override
Future<Map<String, dynamic>> verifyForgotOtp(String email, String code) async {
  try {
    final response = await dio.post(
      "${ApiConstants.authBaseUrl}/verify-forgot-otp",
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
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/reset-password",
        data: {
          "email": email,
          "new_password": newPassword,
        },
      );
      return response.data;
    } on DioException catch (e) {
      return {"error": _handleDioError(e)};
    }
  }

  @override
  Future<Map<String, dynamic>> resendForgotOtp(String email) async {
    try {
      final response = await dio.post(
        "${ApiConstants.authBaseUrl}/resend-forgot-otp",
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
        case 401: return "Login gagal. Periksa kembali email, nomor telepon, atau kata sandi Anda.";
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
