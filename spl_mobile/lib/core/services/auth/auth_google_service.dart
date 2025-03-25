import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/utils/auth_interceptor.dart';
import '../../constants/api.dart';

class AuthGoogleService {
late Dio _dio;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

  
  AuthGoogleService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.authBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(AuthInterceptor(_dio)); // ✅ Ini sekarang aman
  }
  
  Future<Map<String, dynamic>> loginWithGoogle() async {
  try {
    print("🔹 Memulai proses Google Sign-In...");
    await _googleSignIn.signOut();
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return {'error': 'Login dibatalkan oleh pengguna'};
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      return {'error': 'Id Token tidak tersedia'};
    }

    final response = await _dio.post(
      "/google",
      data: {
        "email": googleUser.email,
        "username": googleUser.displayName,
        "idToken": idToken,
        "client": "flutter",
      },
    );

    // 🔍 Cek apakah user diblokir
    final user = response.data["user"];
    if (user != null && user["blocked_until"] != null) {
      final blockedUntil = DateTime.tryParse(user["blocked_until"]);
      if (blockedUntil != null && blockedUntil.isAfter(DateTime.now())) {
        return {
          "error":
              "Akun Anda diblokir hingga ${blockedUntil.toLocal()}. Silakan coba lagi nanti."
        };
      }
    }

    // ✅ Simpan token & user hanya jika aman
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", response.data["token"]);
    await prefs.setString("refresh_token", response.data["refresh_token"]);
    await prefs.setInt("id", user["id"]);
    await prefs.setString("username", user["username"]);
    await prefs.setString("email", user["email"]);
    await prefs.setString("phone_number", user["phone_number"] ?? "");
    await prefs.setInt("type", user["type"]);

    return response.data;
  } on DioError catch (e) {
    // ✅ Handle 403 diblokir dari backend
    if (e.response?.statusCode == 403) {
      final data = e.response?.data;
      if (data != null &&
          data["user"] != null &&
          data["user"]["blocked_until"] != null) {
        final blockedUntil = DateTime.tryParse(data["user"]["blocked_until"]);
        if (blockedUntil != null && blockedUntil.isAfter(DateTime.now())) {
          return {
            "error":
                "Akun Anda diblokir hingga ${blockedUntil.toLocal()}. Silakan coba lagi nanti."
          };
        }
      }
      return {"error": data?["error"] ?? "Akses ditolak oleh server"};
    }

    return {"error": "Login gagal: ${e.message}"};
  } catch (e) {
    return {"error": "Terjadi kesalahan: $e"};
  }
}

}
