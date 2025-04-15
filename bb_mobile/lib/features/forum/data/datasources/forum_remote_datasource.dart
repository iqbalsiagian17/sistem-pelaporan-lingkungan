import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/forum/data/models/forum_post_model.dart';

abstract class ForumRemoteDataSource {
  Future<List<ForumPostModel>> getAllPosts();
  Future<ForumPostModel?> getPostById(int postId);
  Future<bool> createPost({required String content, required List<String> imagePaths});
  Future<bool> updatePost({required int postId, required String content, required List<String> imagePaths});
  Future<bool> createComment({required int postId, required String content});
  Future<bool> updateComment({required int commentId, required String content});
  Future<bool> deletePost(int postId);
  Future<bool> deleteComment(int commentId);

  // Tambahan untuk Like/Unlike & Hitung Like
  Future<bool> likePost(int postId);
  Future<bool> unlikePost(int postId);
  Future<int> getLikeCount(int postId);
  Future<bool> isLiked(int postId);
}

class ForumRemoteDataSourceImpl implements ForumRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<ForumPostModel>> getAllPosts() async {
    try {
      final response = await _dio.get("${ApiConstants.forumUrl}/");
      if (response.statusCode == 200) {
        final data = response.data['posts'] as List;
        return data.map((post) => ForumPostModel.fromJson(post)).toList();
      } else {
        throw Exception("Gagal mengambil postingan forum.");
      }
    } catch (e) {
      _handleError(e, "getAllPosts");
    }
  }

  @override
  Future<ForumPostModel?> getPostById(int postId) async {
    try {
      final response = await _dio.get("${ApiConstants.forumUrl}/$postId");
      if (response.statusCode == 200) {
        return ForumPostModel.fromJson(response.data['post']);
      } else {
        return null;
      }
    } catch (e) {
      _handleError(e, "getPostById");
    }
  }

  @override
  Future<bool> createPost({required String content, required List<String> imagePaths}) async {
    try {
      FormData formData = FormData.fromMap({"content": content});
      for (var path in imagePaths) {
        formData.files.add(MapEntry("images", await MultipartFile.fromFile(path)));
      }
      final response = await _dio.post("${ApiConstants.forumUrl}/", data: formData);
      return response.statusCode == 201;
    } catch (e) {
      _handleError(e, "createPost");
    }
  }

  @override
  Future<bool> updatePost({required int postId, required String content, required List<String> imagePaths,
  }) async {
    try {
      final formData = FormData.fromMap({"content": content});
      for (var path in imagePaths) {
        formData.files.add(MapEntry(
          "images",
          await MultipartFile.fromFile(path),
        ));
      }

      final response = await _dio.put("${ApiConstants.forumUrl}/update/$postId", data: formData);
      return response.statusCode == 200;
    } catch (e) {
      _handleError(e, "updatePost");
    }
  }


  @override
  Future<bool> createComment({required int postId, required String content}) async {
    try {
      final response = await _dio.post("${ApiConstants.forumUrl}/comment", data: {
        "post_id": postId,
        "content": content,
      });
      return response.statusCode == 201;
    } catch (e) {
      _handleError(e, "createComment");
    }
  }

@override
Future<bool> updateComment({required int commentId, required String content}) async {
  try {
    final response = await _dio.put(
      "${ApiConstants.forumUrl}/comment/update/$commentId",
      data: {"content": content},
    );
    return response.statusCode == 200;
  } catch (e) {
    _handleError(e, "updateComment");
  }
}


  @override
  Future<bool> deletePost(int postId) async {
    try {
      final response = await _dio.delete("${ApiConstants.forumUrl}/$postId");
      return response.statusCode == 200;
    } catch (e) {
      _handleError(e, "deletePost");
    }
  }

  @override
  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete("${ApiConstants.forumUrl}/comment/$commentId");
      return response.statusCode == 200;
    } catch (e) {
      _handleError(e, "deleteComment");
    }
  }

  @override
Future<bool> likePost(int postId) async {
  try {
    final response = await _dio.post("${ApiConstants.userPostLike}/$postId/like");
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    _handleError(e, "likePost");
  }
}

@override
Future<bool> unlikePost(int postId) async {
  try {
    final response = await _dio.delete("${ApiConstants.userPostLike}/$postId/unlike");
    return response.statusCode == 200;
  } catch (e) {
    _handleError(e, "unlikePost");
  }
}

@override
Future<bool> isLiked(int postId) async {
  try {
    final response = await _dio.get("${ApiConstants.userPostLike}/$postId/status");
    return response.statusCode == 200 && response.data['isLiked'] == true;
  } catch (e) {
    _handleError(e, "isLiked");
  }
}

@override
Future<int> getLikeCount(int postId) async {
  try {
    final response = await _dio.get("${ApiConstants.userPostLike}/$postId");
    if (response.statusCode == 200 && response.data.containsKey('total_likes')) {
      return response.data['total_likes'] ?? 0;
    }
    return 0;
  } catch (e) {
    _handleError(e, "getLikeCount");
  }
}

  Never _handleError(dynamic e, String context) {
    throw Exception(" [$context] ${e is DioException ? e.response?.data['error'] ?? e.message : e.toString()}");
  }
}