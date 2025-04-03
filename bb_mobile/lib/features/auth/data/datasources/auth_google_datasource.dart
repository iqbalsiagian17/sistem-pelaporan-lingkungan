import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/core/services/firebase/firebase_token_helper.dart';

abstract class AuthGoogleDataSource {
  Future<Map<String, dynamic>> loginWithGoogle();
  Future<void> logoutFromGoogle();
}

class AuthGoogleDataSourceImpl implements AuthGoogleDataSource {
  final Dio _dio;
  final GoogleSignIn _googleSignIn;

  AuthGoogleDataSourceImpl()
      : _dio = DioClient.instance,
        _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      print("🔹 Memulai proses Google Sign-In...");
      await _googleSignIn.signOut(); // Clear session
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'error': 'Login dibatalkan oleh pengguna.'};
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'error': 'Id Token tidak tersedia.'};
      }

      final response = await _dio.post(
        "${ApiConstants.authBaseUrl}/google",
        data: {
          "email": googleUser.email,
          "username": googleUser.displayName,
          "idToken": idToken,
          "client": "flutter",
        },
      );

      final user = response.data["user"];
      final accessToken = response.data["token"];
      final refreshToken = response.data["refresh_token"];

      if (user != null && accessToken != null && refreshToken != null) {
        if (user["blocked_until"] != null) {
          final blockedUntil = DateTime.tryParse(user["blocked_until"]);
          if (blockedUntil != null && blockedUntil.isAfter(DateTime.now())) {
            return {
              "error":
                  "Akun Anda diblokir hingga ${blockedUntil.toLocal()}. Silakan coba lagi nanti."
            };
          }
        }

        await globalAuthService.saveToken(accessToken, refreshToken);
        await globalAuthService.saveUserInfo(user);
        await saveFcmTokenToBackend(user["id"]);

        return response.data;
      }

      return {'error': 'Login gagal. Data tidak lengkap.'};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 403 && data != null) {
        final blockedUntil = DateTime.tryParse(data["user"]?["blocked_until"] ?? "");
        if (blockedUntil != null && blockedUntil.isAfter(DateTime.now())) {
          return {
            "error":
                "Akun Anda diblokir hingga ${blockedUntil.toLocal()}. Silakan coba lagi nanti."
          };
        }
        return {"error": data["error"] ?? "Akses ditolak oleh server"};
      }

      return {"error": "Login gagal: ${e.message}"};
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  @override
  Future<void> logoutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      await globalAuthService.clearAuthData();
      print("✅ Logout Google berhasil.");
    } catch (e) {
      print("❌ Gagal logout Google: $e");
    }
  }
}
