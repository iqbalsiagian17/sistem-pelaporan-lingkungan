import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/user/report/user_report_service.dart';
import 'package:spl_mobile/models/Report.dart'; // ✅ Gunakan konsisten huruf besar

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  List<Report> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ Ambil Token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  

  // ✅ Ambil semua laporan
Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token yang tersedia. Silakan login ulang.");
      }

      debugPrint("🔍 Mengambil laporan dari API...");
      final fetchedReports = await _reportService.getAllReports();
      
      debugPrint("📢 Data diterima dari API: ${fetchedReports.length}");
      _reports = List<Report>.from(fetchedReports);
      
    } catch (e) {
      debugPrint("❌ Error saat fetchReports: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
}


  // ✅ Ambil laporan berdasarkan ID
Future<Report?> getReportById(String reportId) async {
  try {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("❌ Tidak ada token yang tersedia. Silakan login ulang.");
    }

    final report = await _reportService.getReportById(reportId);
    return report as Report?;  // ✅ Paksa casting agar cocok
  } catch (e) {
    _errorMessage = e.toString();
    notifyListeners();
    return null;
  }
}



  // ✅ Tambah laporan baru
   Future<bool> createReport({
    required String title,
    required String description,
    required String date,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments, // ✅ Tambahkan attachments sebagai parameter
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token. Silakan login ulang.");
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
        attachments: attachments, // ✅ Kirim attachments ke service
      );

      if (success) {
        await fetchReports();
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ✅ Hapus laporan
  Future<bool> deleteReport(String reportId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token yang tersedia. Silakan login ulang.");
      }

      bool success = await _reportService.deleteReport(reportId);

      if (success) {
        _reports.removeWhere((report) => report.id.toString() == reportId);
        notifyListeners();
      }

      _isLoading = false;
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
