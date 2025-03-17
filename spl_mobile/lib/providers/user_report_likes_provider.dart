import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/likes/report_likes_service.dart';

class ReportLikeProvider with ChangeNotifier {
  final ReportLikeService _reportLikeService = ReportLikeService();
  final Set<int> _likedReports = {}; // ✅ Menyimpan laporan yang telah di-like

  /// 🔹 Mengecek apakah laporan sudah di-like secara lokal
  bool isLiked(int reportId) => _likedReports.contains(reportId);

  /// 🔹 Mengambil status like dari API dan menyimpannya ke `_likedReports`
  Future<void> fetchLikeStatus(int reportId, String token) async {
    bool liked = await _reportLikeService.isLiked(reportId, token);
    if (liked) {
      _likedReports.add(reportId);
    } else {
      _likedReports.remove(reportId);
    }
    notifyListeners();
  }

  /// 🔹 Menyukai laporan dan memperbarui status lokal
  Future<void> likeReport(int reportId, String token) async {
    bool success = await _reportLikeService.likeReport(reportId, token);
    if (success) {
      _likedReports.add(reportId);
      notifyListeners();
      print("✅ [likeReport] Laporan $reportId berhasil di-like.");
    }
  }

  /// 🔹 Menghapus like dari laporan dan memperbarui status lokal
  Future<void> unlikeReport(int reportId, String token) async {
    bool success = await _reportLikeService.unlikeReport(reportId, token);
    if (success) {
      _likedReports.remove(reportId);
      notifyListeners();
      print("✅ [unlikeReport] Laporan $reportId berhasil di-unlike.");
    }
  }
}
