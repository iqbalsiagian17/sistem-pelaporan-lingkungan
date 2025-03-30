import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spl_mobile/core/services/user/report/user_report_service.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  List<Report> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// ✅ Cek apakah user punya laporan yang masih belum selesai
  bool hasPendingReports(int currentUserId) {
    if (_reports.isEmpty) return false;

    return _reports.any((report) =>
        report.userId == currentUserId &&
        report.status != "closed" &&
        report.status != "rejected");
  }

  /// ✅ Ambil semua laporan dari backend
  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("🔍 Mengambil laporan dari API...");
      final fetchedReports = await _reportService.getAllReports();
      debugPrint("📢 Data laporan: ${fetchedReports.length}");

      _reports = List<Report>.from(fetchedReports);
    } catch (e) {
      debugPrint("❌ Gagal fetch laporan: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Ambil laporan berdasarkan ID
  Future<Report?> getReportById(String reportId) async {
    try {
      final report = await _reportService.getReportById(reportId);
      return report;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// ✅ Buat laporan baru
  Future<bool> createReport({
    required String title,
    required String description,
    required String date,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = await globalAuthService.getUserId();

      if (currentUserId != null && hasPendingReports(currentUserId)) {
        throw Exception("Anda masih memiliki laporan yang belum selesai.");
      }

      bool success = await _reportService.createReport(
        title: title,
        description: description,
        date: date,
        locationDetails: locationDetails,
        village: village,
        latitude: latitude,
        longitude: longitude,
        isAtLocation: isAtLocation,
        attachments: attachments,
      );

      if (success) {
        await fetchReports();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Hapus laporan
  Future<bool> deleteReport(String reportId) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _reportService.deleteReport(reportId);

      if (success) {
        _reports.removeWhere((report) => report.id.toString() == reportId);
        debugPrint("🗑️ Laporan dengan ID $reportId dihapus.");
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error hapus laporan: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
