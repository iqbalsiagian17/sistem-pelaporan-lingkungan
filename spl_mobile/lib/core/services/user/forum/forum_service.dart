import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/models/Forum.dart';

class ForumService {
  final Dio _dio = DioClient.instance;

  /// ✅ Ambil Semua Postingan Forum
  Future<List<ForumPost>> getAllPosts() async {
    try {
      final response = await _dio.get("${ApiConstants.forumUrl}/");
      print("📥 Response API: ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['posts'];
        return data.map((post) => ForumPost.fromJson(post)).toList();
      } else {
        throw Exception("Gagal mengambil postingan forum.");
      }
    } catch (e) {
      _handleError(e, "getAllPosts");
    }
  }

  /// ✅ Ambil Postingan Forum Berdasarkan ID
  Future<ForumPost?> getPostById(int postId) async {
    try {
      final response = await _dio.get("${ApiConstants.forumUrl}/$postId");

      if (response.statusCode == 200) {
        return ForumPost.fromJson(response.data['post']);
      } else {
        return null;
      }
    } catch (e) {
      _handleError(e, "getPostById");
    }
  }

  /// ✅ Buat Postingan Baru
  Future<bool> createPost({
    required String content,
    required List<String> imagePaths,
  }) async {
    try {
      FormData formData = FormData.fromMap({"content": content});
      for (var imagePath in imagePaths) {
        formData.files.add(MapEntry(
          "images",
          await MultipartFile.fromFile(imagePath),
        ));
      }

      final response = await _dio.post(
        "${ApiConstants.forumUrl}/",
        data: formData,
      );

      return response.statusCode == 201;
    } catch (e) {
      _handleError(e, "createPost");
    }
  }

  /// ✅ Tambah Komentar
  Future<bool> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.forumUrl}/comment",
        data: {
          "post_id": postId,
          "content": content,
        },
      );

      return response.statusCode == 201;
    } catch (e) {
      _handleError(e, "createComment");
    }
  }

  /// ✅ Hapus Postingan
  Future<bool> deletePost(int postId) async {
    try {
      final response = await _dio.delete("${ApiConstants.forumUrl}/$postId");
      return response.statusCode == 200;
    } catch (e) {
      _handleError(e, "deletePost");
    }
  }

  /// ✅ Hapus Komentar
  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete("${ApiConstants.forumUrl}/comment/$commentId");
      return response.statusCode == 200;
    } catch (e) {
      _handleError(e, "deleteComment");
    }
  }

  /// 🔥 Helper error
  Never _handleError(dynamic e, String context) {
    throw Exception("❌ [$context] ${e is DioException ? e.response?.data['error'] ?? e.message : e.toString()}");
  }
}
