import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/dio_client.dart';
import 'package:spl_mobile/core/constants/api.dart'; // ✅ Tambahkan ini
import '../../../../models/ReportSave.dart';

class ReportSaveService {
  final Dio _dio = DioClient.instance; // ✅ Gunakan Dio dengan interceptor

  /// ✅ Ambil semua laporan yang disimpan user
  Future<List<ReportSave>> fetchSavedReports() async {
    try {
      final response = await _dio.get("${ApiConstants.userReportSave}/");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['savedReports'];
        return data.map((json) => ReportSave.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil laporan yang disimpan.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// ✅ Simpan laporan ke favorit
  Future<void> saveReport(int reportId) async {
    try {
      await _dio.post("${ApiConstants.userReportSave}/", data: {
        "report_id": reportId,
      });
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menyimpan laporan: $e");
    }
  }

  /// ✅ Hapus laporan dari favorit
  Future<void> deleteSavedReport(int reportId) async {
    try {
      await _dio.delete("${ApiConstants.userReportSave}/$reportId");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menghapus laporan: $e");
    }
  }
}
