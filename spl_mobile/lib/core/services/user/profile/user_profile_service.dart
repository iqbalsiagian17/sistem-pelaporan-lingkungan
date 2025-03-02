import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
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
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> createUserProfile(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.post(
        "/create",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }


  // ✅ Update profil pengguna
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
      return {"error": e.toString()};
    }
  }

  // ✅ Upload Foto Profil
  Future<Map<String, dynamic>> uploadProfilePicture(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"error": "Token tidak ditemukan"};
      }

      String fileName = imageFile.path.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();

      // ✅ Pastikan format file sesuai
      if (fileExtension != "jpg" && fileExtension != "jpeg" && fileExtension != "png") {
        return {"error": "Format file tidak didukung. Harap unggah gambar JPG atau PNG."};
      }

      FormData formData = FormData.fromMap({
        "profile_picture": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType("image", fileExtension), // ✅ Pastikan Content-Type benar
        ),
      });

      final response = await _dio.put(
        "/update-profile-picture",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
          contentType: "multipart/form-data", // ✅ Tetapkan Content-Type
        ),
      );

      return response.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
