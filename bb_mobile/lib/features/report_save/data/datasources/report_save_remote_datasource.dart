import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/features/report_save/data/models/report_save_model.dart';
import 'package:dio/dio.dart';

abstract class ReportSaveRemoteDatasource {
  Future<List<ReportSaveModel>> fetchSavedReports();
  Future<void> saveReport(int reportId);
  Future<void> deleteSavedReport(int reportId);
}

class ReportSaveRemoteDatasourceImpl implements ReportSaveRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<ReportSaveModel>> fetchSavedReports() async {
    try {
      final response = await _dio.get("${ApiConstants.userReportSave}/");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['savedReports'];
        return data.map((e) => ReportSaveModel.fromJson(e)).toList();
      } else {
        throw Exception("Gagal mengambil laporan tersimpan.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<void> saveReport(int reportId) async {
    try {
      await _dio.post("${ApiConstants.userReportSave}/", data: {
        "report_id": reportId,
      });
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menyimpan laporan: $e");
    }
  }

  @override
  Future<void> deleteSavedReport(int reportId) async {
    try {
      await _dio.delete("${ApiConstants.userReportSave}/$reportId");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menghapus laporan: $e");
    }
  }
}
