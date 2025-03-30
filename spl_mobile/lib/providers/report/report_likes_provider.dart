import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/likes/report_likes_service.dart';

class ReportLikeProvider with ChangeNotifier {
  final ReportLikeService _reportLikeService = ReportLikeService();
  final Set<int> _likedReports = {};
  final Map<int, int> _likeCounts = {};

  /// 🔹 Mengecek apakah laporan sudah di-like secara lokal
  bool isLiked(int reportId) => _likedReports.contains(reportId);

  /// 🔹 Mengambil jumlah likes dari API
  int getLikeCount(int reportId) {
    return _likeCounts[reportId] ?? 0;
  }

  /// 🔹 Fetch jumlah likes dari API
  Future<void> fetchLikeCount(int reportId) async {
    int count = await _reportLikeService.getLikeCount(reportId);
    _likeCounts[reportId] = count;
    notifyListeners();
  }

  /// 🔹 Fetch status like dari API
  Future<void> fetchLikeStatus(int reportId) async {
    bool liked = await _reportLikeService.isLiked(reportId);
    if (liked) {
      _likedReports.add(reportId);
    } else {
      _likedReports.remove(reportId);
    }
    notifyListeners();
  }

  /// 🔹 Menyukai laporan
  Future<void> likeReport(int reportId) async {
    bool success = await _reportLikeService.likeReport(reportId);
    if (success) {
      _likedReports.add(reportId);
      _likeCounts[reportId] = (_likeCounts[reportId] ?? 0) + 1;
      notifyListeners();
      print("✅ [likeReport] Laporan $reportId berhasil di-like.");
    }
  }

  /// 🔹 Menghapus like dari laporan
  Future<void> unlikeReport(int reportId) async {
    bool success = await _reportLikeService.unlikeReport(reportId);
    if (success) {
      _likedReports.remove(reportId);
      _likeCounts[reportId] = (_likeCounts[reportId] ?? 1) - 1;
      notifyListeners();
      print("✅ [unlikeReport] Laporan $reportId berhasil di-unlike.");
    }
  }
}
