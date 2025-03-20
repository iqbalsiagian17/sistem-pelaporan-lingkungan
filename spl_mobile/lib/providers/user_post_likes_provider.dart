import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/likes/post_likes_services.dart';

class PostLikeProvider with ChangeNotifier {
  final PostLikeService _postLikeService = PostLikeService();
  
  /// ✅ Menyimpan daftar post yang di-like per user {userId: {postId1, postId2, ...}}
  final Map<int, Set<int>> _likedPosts = {}; 

  /// ✅ Menyimpan jumlah likes dari API {postId: jumlah_likes}
  final Map<int, int> _likeCounts = {}; 

  /// 🔹 Mengecek apakah user tertentu sudah melike suatu postingan
  bool isLiked(int userId, int postId) {
    return _likedPosts[userId]?.contains(postId) ?? false;
  }

  /// 🔹 Mengambil jumlah likes dari cache (_likeCounts)
  int getLikeCount(int postId) {
    return _likeCounts[postId] ?? 0;
  }

  /// 🔹 Fetch jumlah likes dari API
Future<int> fetchLikeCount(int postId, String token) async {
    try {
      print("🔍 [fetchLikeCount] Mengambil jumlah like untuk Post ID: $postId");
      int count = await _postLikeService.getLikeCount(postId, token);
      _likeCounts[postId] = count;
      notifyListeners();
      return count; // ✅ Perbaikan: Sekarang mengembalikan `int`
    } catch (e) {
      print("❌ [fetchLikeCount] Error: $e");
      return 0;
    }
  }

  Future<bool> fetchLikeStatus(int userId, int postId, String token) async {
    try {
      bool liked = await _postLikeService.isLiked(postId, token);
      if (liked) {
        _likedPosts.putIfAbsent(userId, () => {}).add(postId);
      } else {
        _likedPosts[userId]?.remove(postId);
      }
      notifyListeners();
      return liked; // ✅ Perbaikan: Sekarang mengembalikan `bool`
    } catch (e) {
      print("❌ [fetchLikeStatus] Error: $e");
      return false;
    }
  }

  /// 🔹 Menyukai postingan dan langsung memperbarui jumlah likes
  Future<void> likePost(int userId, int postId, String token) async {
    try {
      bool success = await _postLikeService.likePost(postId, token);

      if (success) {
        _likedPosts.putIfAbsent(userId, () => {}).add(postId);
        
        // 🔥 **Ambil data terbaru langsung dari API**
        await fetchLikeCount(postId, token);
        
        notifyListeners(); // ✅ Perbarui UI agar langsung berubah
        print("✅ [likePost] User $userId menyukai postingan $postId.");
      }
    } catch (e) {
      print("❌ [likePost] Error: $e");
    }
  }

  /// 🔹 Menghapus like dari postingan dan memperbarui jumlah likes
  Future<void> unlikePost(int userId, int postId, String token) async {
    try {
      bool success = await _postLikeService.unlikePost(postId, token);

      if (success) {
        _likedPosts[userId]?.remove(postId);
        
        // 🔥 **Ambil data terbaru langsung dari API**
        await fetchLikeCount(postId, token);
        
        notifyListeners(); // ✅ Perbarui UI
        print("✅ [unlikePost] User $userId menghapus like dari postingan $postId.");
      }
    } catch (e) {
      print("❌ [unlikePost] Error: $e");
    }
  }
}
