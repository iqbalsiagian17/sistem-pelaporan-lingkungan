import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/forum/forum_service.dart';
import 'package:spl_mobile/models/Forum.dart';

class ForumProvider with ChangeNotifier {
  final ForumService _forumService = ForumService();

  List<ForumPost> _posts = [];
  ForumPost? _selectedPost;
  bool _isLoading = false;
  String? _errorMessage;

  List<ForumPost> get posts => _posts;
  ForumPost? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// ✅ **Ambil Semua Postingan Forum**
Future<void> fetchAllPosts() async {
  if (_isLoading) return;
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    print("🔍 Fetching forum posts...");
    final fetchedPosts = await _forumService.getAllPosts();

    if (fetchedPosts.isEmpty) {
      print("⚠️ Tidak ada postingan ditemukan.");
    } else {
      print("✅ ${fetchedPosts.length} postingan berhasil diambil.");
    }

    _posts = fetchedPosts;
  } catch (e) {
    _errorMessage = "❌ Error fetching forum posts: $e";
    print(_errorMessage);
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// ✅ **Ambil Detail Postingan Berdasarkan ID**
/// ✅ **Ambil Detail Postingan Berdasarkan ID**
Future<ForumPost?> fetchPostById(int postId) async {
  if (_isLoading) return null; // ⛔ Hindari multiple request
  _isLoading = true;
  notifyListeners();

  try {
    debugPrint("🔍 Fetching post ID: $postId...");
    final post = await _forumService.getPostById(postId);

    if (post != null) {
      _selectedPost = post;
      debugPrint("✅ Post found: ${post.content}");
      return post; // ✅ Kembalikan post yang ditemukan
    } else {
      _errorMessage = "❌ Post not found";
    }
  } catch (e) {
    _errorMessage = "❌ Error fetching post: $e";
    debugPrint(_errorMessage);
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  
  return null; // ✅ Jika terjadi error, kembalikan `null`
}


  /// ✅ **Buat Postingan Baru**
  Future<bool> createPost({required String content, required List<String> imagePaths}) async {
  const int maxImages = 5;

  // ✅ Validasi maksimal 5 gambar
  if (imagePaths.length > maxImages) {
    _errorMessage = "❌ Maksimal hanya dapat mengunggah $maxImages gambar!";
    debugPrint(_errorMessage);
    
    // 🔹 Beri tahu UI kalau ada error
    notifyListeners();
    return false;
  }

  _isLoading = true;
  notifyListeners();

  try {
    debugPrint("📝 Creating post...");
    bool success = await _forumService.createPost(content: content, imagePaths: imagePaths);
    
    if (success) {
      debugPrint("✅ Post created successfully");
      await fetchAllPosts();
    }
    return success;
  } catch (e) {
    _errorMessage = "❌ Error creating post: $e";
    debugPrint(_errorMessage);
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// ✅ **Tambah Komentar di Postingan Forum**
  Future<bool> addComment({required int postId, required String content}) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("💬 Adding comment to post ID: $postId...");
      bool success = await _forumService.createComment(postId: postId, content: content);
      if (success) {
        debugPrint("✅ Comment added");
        await fetchPostById(postId); // 🔄 Update detail post setelah komentar
      }
      return success;
    } catch (e) {
      _errorMessage = "❌ Error adding comment: $e";
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ **Hapus Postingan**
  Future<bool> removePost(int postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🗑️ Deleting post ID: $postId...");
      bool success = await _forumService.deletePost(postId);
      if (success) {
        _posts.removeWhere((post) => post.id == postId);
        debugPrint("✅ Post deleted");
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = "❌ Error deleting post: $e";
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ **Hapus Komentar**
  Future<bool> removeComment(int commentId, int postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🗑️ Deleting comment ID: $commentId...");
      bool success = await _forumService.deleteComment(commentId);
      if (success) {
        debugPrint("✅ Comment deleted");
        await fetchPostById(postId); // 🔄 Update post detail setelah komentar dihapus
      }
      return success;
    } catch (e) {
      _errorMessage = "❌ Error deleting comment: $e";
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
