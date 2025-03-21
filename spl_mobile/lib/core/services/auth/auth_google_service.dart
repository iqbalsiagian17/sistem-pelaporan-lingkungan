import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/api.dart';

class AuthGoogleService {
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);



  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.authBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      print("🔹 Memulai proses Google Sign-In...");
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ Pengguna membatalkan login Google.");
        return {'error': 'Login dibatalkan oleh pengguna'};
      }

      print("✅ Google user ditemukan: ${googleUser.displayName} (${googleUser.email})");

      final googleAuth = await googleUser.authentication;
      print("🔹 Mengambil authentication dari Google...");

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      print("🔹 accessToken: $accessToken"); // opsional
      if (idToken == null) {
        print("❌ Id Token tidak tersedia");
        return {'error': 'Id Token tidak tersedia'};
      }

      print("✅ Id Token berhasil diperoleh");

      // Kirim ke backend
      print("🔹 Mengirim request ke backend...");

      final response = await _dio.post(
        "/google",
        data: {
          "email": googleUser.email,
          "username": googleUser.displayName,
          "idToken": idToken,
          "client": "flutter",
        },
      );

      print("✅ Respons diterima dari server: ${response.data}");

      // Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      print("🔹 Menyimpan token ke SharedPreferences...");
      await prefs.setString("token", response.data["token"]);
      await prefs.setString("refresh_token", response.data["refresh_token"]);

      final user = response.data["user"];
      print("🔹 Menyimpan data user ke SharedPreferences...");
      await prefs.setInt("id", user["id"]);
      await prefs.setString("username", user["username"]);
      await prefs.setString("email", user["email"]);
      await prefs.setString("phone_number", user["phone_number"] ?? "");
      await prefs.setInt("type", user["type"]);

      print("✅ Semua data berhasil disimpan ke SharedPreferences.");

      return response.data;
    } catch (e) {
      print("❌ Terjadi error saat login Google: $e");

      if (e is DioError) {
        print("🔴 Dio Error: ${e.message}");
        print("🔴 Dio Request: ${e.requestOptions.path}");
        if (e.response != null) {
          print("🔴 Dio Response Status: ${e.response?.statusCode}");
          print("🔴 Dio Response Body: ${e.response?.data}");
        }
      } else {
        print("🔴 General Error: $e");
      }

      return {"error": "Login Google gagal: $e"};
    }
  }
}
