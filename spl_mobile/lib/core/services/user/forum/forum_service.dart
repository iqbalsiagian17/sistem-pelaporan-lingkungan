import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api.dart';
import '../../../../models/Forum.dart';

class ForumService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.forumUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// ✅ **Ambil Token dari SharedPreferences**
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// ✅ **Ambil Semua Postingan Forum**
Future<List<ForumPost>> getAllPosts() async {
  try {
    final token = await _getToken();
    final response = await _dio.get(
      "/",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    print("📥 Response API: ${response.data}");

    if (response.statusCode == 200) {
      List<dynamic> data = response.data['posts'];
      return data.map((post) => ForumPost.fromJson(post)).toList();
    } else {
      throw Exception("Gagal mengambil postingan forum.");
    }
  } catch (e) {
    throw Exception("❌ Error fetching forum posts: $e");
  }
}


  /// ✅ **Ambil Postingan Forum Berdasarkan ID**
  Future<ForumPost?> getPostById(int postId) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        "/$postId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return ForumPost.fromJson(response.data['post']);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("❌ Error fetching forum post: $e");
    }
  }

  /// ✅ **Buat Postingan Baru**
  Future<bool> createPost({
    required String content,
    required List<String> imagePaths,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Tidak ada token, silakan login.");

      FormData formData = FormData.fromMap({"content": content});

      for (var imagePath in imagePaths) {
        formData.files.add(MapEntry(
          "images",
          await MultipartFile.fromFile(imagePath),
        ));
      }

      final response = await _dio.post(
        "/",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception("❌ Error creating post: $e");
    }
  }

  /// ✅ **Tambah Komentar di Postingan Forum**
  Future<bool> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Tidak ada token, silakan login.");

      final response = await _dio.post(
        "/comment",
        data: {"post_id": postId, "content": content},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception("❌ Error creating comment: $e");
    }
  }

  /// ✅ **Hapus Postingan**
  Future<bool> deletePost(int postId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Tidak ada token, silakan login.");

      final response = await _dio.delete(
        "/$postId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("❌ Error deleting post: $e");
    }
  }

  /// ✅ **Hapus Komentar**
  Future<bool> deleteComment(int commentId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Tidak ada token, silakan login.");

      final response = await _dio.delete(
        "/comment/$commentId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("❌ Error deleting comment: $e");
    }
  }
}
