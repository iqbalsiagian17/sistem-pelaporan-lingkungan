import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/likes/report_likes_service.dart';

class ReportLikeProvider with ChangeNotifier {
  final ReportLikeService _reportLikeService = ReportLikeService();
  final Set<int> _likedReports = {}; // ✅ Menyimpan laporan yang telah di-like
  final Map<int, int> _likeCounts = {}; // ✅ Menyimpan jumlah like dari API

  /// 🔹 Mengecek apakah laporan sudah di-like secara lokal
  bool isLiked(int reportId) => _likedReports.contains(reportId);

  /// 🔹 Mengambil jumlah likes dari API
  int getLikeCount(int reportId) {
    return _likeCounts[reportId] ?? 0; // ✅ Pastikan tidak null
  }

  /// 🔹 Fetch jumlah likes dari API dan pastikan tidak overwrite nilai awal dari database
  Future<void> fetchLikeCount(int reportId, String token) async {
    int count = await _reportLikeService.getLikeCount(reportId, token);
    if (count > 0) {
      _likeCounts[reportId] = count;
      notifyListeners();
    }
  }

  /// 🔹 Fetch status like dari API
  Future<void> fetchLikeStatus(int reportId, String token) async {
    bool liked = await _reportLikeService.isLiked(reportId, token);
    if (liked) {
      _likedReports.add(reportId);
    } else {
      _likedReports.remove(reportId);
    }
    notifyListeners();
  }

  /// 🔹 Menyukai laporan dan memperbarui jumlah likes
  Future<void> likeReport(int reportId, String token) async {
    bool success = await _reportLikeService.likeReport(reportId, token);
    if (success) {
      _likedReports.add(reportId);
      _likeCounts[reportId] = (_likeCounts[reportId] ?? 0) + 1; // ✅ Tambah jumlah likes
      notifyListeners();
      print("✅ [likeReport] Laporan $reportId berhasil di-like.");
    }
  }

  /// 🔹 Menghapus like dari laporan dan memperbarui jumlah likes
  Future<void> unlikeReport(int reportId, String token) async {
    bool success = await _reportLikeService.unlikeReport(reportId, token);
    if (success) {
      _likedReports.remove(reportId);
      _likeCounts[reportId] = (_likeCounts[reportId] ?? 1) - 1; // ✅ Kurangi jumlah likes
      notifyListeners();
      print("✅ [unlikeReport] Laporan $reportId berhasil di-unlike.");
    }
  }
}
