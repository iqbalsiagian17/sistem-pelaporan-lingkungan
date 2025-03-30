import 'package:flutter/material.dart';
import '../../core/services/user/save/report_save_service.dart';
import '../../models/ReportSave.dart';

class ReportSaveProvider with ChangeNotifier {
  final ReportSaveService _reportSaveService = ReportSaveService();

  List<ReportSave> _savedReports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReportSave> get savedReports => _savedReports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// ✅ Cek apakah laporan sudah disimpan
  bool isReportSaved(int reportId) {
    return _savedReports.any((report) => report.reportId == reportId);
  }

  /// ✅ Ambil semua laporan yang disimpan user
  Future<void> fetchSavedReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("🔍 Mengambil laporan tersimpan dari API...");

      final fetchedReports = await _reportSaveService.fetchSavedReports();
      debugPrint("📢 Data diterima: ${fetchedReports.length} laporan tersimpan.");

      _savedReports = fetchedReports;
    } catch (e) {
      debugPrint("❌ Error saat fetchSavedReports: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Simpan laporan ke daftar tersimpan
  Future<void> saveReport(int reportId) async {
    try {
      await _reportSaveService.saveReport(reportId);
      await fetchSavedReports();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// ✅ Hapus laporan dari daftar tersimpan
  Future<void> deleteSavedReport(int reportId) async {
    try {
      await _reportSaveService.deleteSavedReport(reportId);
      _savedReports.removeWhere((report) => report.reportId == reportId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
