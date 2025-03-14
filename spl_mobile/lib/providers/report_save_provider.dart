import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/user/save/report_save_service.dart';
import '../models/ReportSave.dart';

class ReportSaveProvider with ChangeNotifier {
  final ReportSaveService _reportSaveService = ReportSaveService();
  List<ReportSave> _savedReports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReportSave> get savedReports => _savedReports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ Ambil Token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

    bool isReportSaved(int reportId) {
    return _savedReports.any((report) => report.reportId == reportId);
  }

  // ✅ Ambil laporan yang disimpan oleh user
 Future<void> fetchSavedReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token. Silakan login ulang.");
      }

      debugPrint("🔍 Mengambil laporan tersimpan dari API...");
      
      final fetchedReports = await _reportSaveService.fetchSavedReports(token);

      debugPrint("📢 Data diterima: ${fetchedReports.length} laporan tersimpan.");
      
      _savedReports = List<ReportSave>.from(fetchedReports);
      _errorMessage = null;
    } catch (e) {
      debugPrint("❌ Error saat fetchSavedReports: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // ✅ Simpan laporan
  Future<void> saveReport(int reportId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token.");
      }

      await _reportSaveService.saveReport(reportId, token);
      await fetchSavedReports(); // ✅ Refresh data setelah menyimpan laporan
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ✅ Hapus laporan dari daftar tersimpan
  Future<void> deleteSavedReport(int reportId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token.");
      }

      await _reportSaveService.deleteSavedReport(reportId, token);
      _savedReports.removeWhere((report) => report.reportId == reportId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
