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

  /// ✅ Ambil Semua Postingan Forum
  Future<void> fetchAllPosts() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("🔍 Fetching forum posts...");
      final fetchedPosts = await _forumService.getAllPosts();

      if (fetchedPosts.isEmpty) {
        debugPrint("⚠️ Tidak ada postingan ditemukan.");
      } else {
        debugPrint("✅ ${fetchedPosts.length} postingan berhasil diambil.");
      }

      _posts = fetchedPosts;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error fetching forum posts: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Ambil Detail Postingan Berdasarkan ID
  Future<ForumPost?> fetchPostById(int postId) async {
    if (_isLoading) return null;
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🔍 Fetching post ID: $postId...");
      final post = await _forumService.getPostById(postId);

      if (post != null) {
        _selectedPost = post;
        debugPrint("✅ Post ditemukan: ${post.content}");
        return post;
      } else {
        _errorMessage = "❌ Post tidak ditemukan";
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error fetching post: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }

  /// ✅ Buat Postingan Baru
  Future<bool> createPost({required String content, required List<String> imagePaths}) async {
    const int maxImages = 5;
    if (imagePaths.length > maxImages) {
      _errorMessage = "❌ Maksimal hanya dapat mengunggah $maxImages gambar!";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("📝 Membuat postingan...");
      final success = await _forumService.createPost(content: content, imagePaths: imagePaths);

      if (success) {
        debugPrint("✅ Post berhasil dibuat");
        await fetchAllPosts();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error creating post: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Tambah Komentar
  Future<bool> addComment({required int postId, required String content}) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("💬 Menambahkan komentar ke post ID: $postId...");
      final success = await _forumService.createComment(postId: postId, content: content);

      if (success) {
        debugPrint("✅ Komentar berhasil ditambahkan");
        await fetchPostById(postId);
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error adding comment: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Hapus Postingan
  Future<bool> removePost(int postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🗑️ Menghapus post ID: $postId...");
      final success = await _forumService.deletePost(postId);

      if (success) {
        _posts.removeWhere((post) => post.id == postId);
        debugPrint("✅ Post berhasil dihapus");
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error deleting post: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Hapus Komentar
  Future<bool> removeComment(int commentId, int postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("🗑️ Menghapus komentar ID: $commentId...");
      final success = await _forumService.deleteComment(commentId);

      if (success) {
        debugPrint("✅ Komentar berhasil dihapus");
        await fetchPostById(postId);
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error deleting comment: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Reset State (Saat Logout atau Clear)
  void clearState() {
    _posts = [];
    _selectedPost = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
