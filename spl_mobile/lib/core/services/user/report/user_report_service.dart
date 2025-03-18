import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/api.dart';
import '../../../../models/Report.dart';

class ReportService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.userReportUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

  // ✅ Ambil Token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ✅ Ambil Semua Laporan
Future<List<Report>> getAllReports() async {
  try {
    final token = await _getToken();
    final response = await _dio.get(
      '${ApiConstants.userReportUrl}/all',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['reports'];

        return data.map((report) => Report.fromJson(report)).toList();
      } else {
        throw Exception("❌ Gagal mengambil data laporan. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ Terjadi kesalahan saat mengambil laporan: $e");
    }
  }





  // ✅ Ambil Laporan Berdasarkan ID
Future<Report?> getReportById(String reportId) async {
  try {
    final response = await _dio.get('/reports/$reportId');

    if (response.statusCode == 200) {
      return Report.fromJson(response.data['report']);
    } else {
      return null; // ✅ Kembalikan `null` jika tidak ada laporan
    }
  } catch (e) {
    return null; // ✅ Tangani error dengan mengembalikan `null`
  }
}


  // ✅ Buat Laporan Baru
  Future<bool> createReport({
  required String title,
  required String description,
  required String date,
  String? locationDetails,
  String? village,
  String? latitude,
  String? longitude,
  bool? isAtLocation,
  List<File>? attachments, // Pastikan parameter attachments ada
}) async {
  try {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("❌ Tidak ada token. Silakan login ulang.");
    }

    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "date": date.split("T")[0],
        "location_details": (locationDetails != null && locationDetails.isNotEmpty)
            ? locationDetails.trim()
            : "Tidak ada detail lokasi", // ✅ Pastikan tetap dikirim sebagai string
      "village": isAtLocation == false && (village?.isNotEmpty ?? false) ? village : null,
      "latitude": isAtLocation == true ? latitude : "0.0",
      "longitude": isAtLocation == true ? longitude : "0.0",
      "is_at_location": isAtLocation.toString(),
    });

    // ✅ Tambahkan file jika ada
// ✅ Pastikan hanya ada satu loop untuk menghindari duplikasi
if (attachments != null && attachments.isNotEmpty) {
  for (var file in attachments) { 
    String fileName = file.path.split('/').last;
    formData.files.add(
      MapEntry(
        "attachments", // ⚠ Sesuaikan dengan backend, mungkin "attachments[]"
        await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        ),
      ),
    );
  }
}


    final response = await _dio.post(
      '${ApiConstants.userReportUrl}/create',
      data: formData,
      options: Options(headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      }),
    );

    print("✅ Response Code: ${response.statusCode}");
    print("✅ Response Data: ${response.data}");

    return response.statusCode == 201;
  } on DioException catch (e) {
    print("❌ Error createReport: ${e.response?.data}");
    print("❌ Status Code: ${e.response?.statusCode}");
    throw Exception("Gagal membuat laporan: ${e.response?.data}");
  }
}


  // ✅ Hapus Laporan
    Future<bool> deleteReport(String reportId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token. Silakan login ulang.");
      }

      final response = await _dio.delete(
        '${ApiConstants.userReportUrl}/$reportId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        print("✅ Laporan dengan ID $reportId berhasil dihapus.");
        return true;
      } else if (response.statusCode == 400) {
        print("⚠️ Laporan hanya bisa dihapus jika masih berstatus pending.");
        return false;
      } else if (response.statusCode == 403) {
        print("🚫 Anda tidak memiliki izin untuk menghapus laporan ini.");
        return false;
      } else if (response.statusCode == 404) {
        print("❌ Laporan tidak ditemukan.");
        return false;
      } else {
        throw Exception("Gagal menghapus laporan. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error deleteReport: $e");
      throw Exception("Gagal menghapus laporan: $e");
    }
  }

Future<List<Report>> getUserReports() async {
  try {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("❌ Tidak ada token. Silakan login ulang.");
    }

    debugPrint("🔍 Fetching user reports...");

    final response = await _dio.get(
      '${ApiConstants.userReportUrl}/all', // 🔹 Ambil semua laporan
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.data['reports'];

      // 🔍 **Ambil user ID dari SharedPreferences**
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("user_id");

      if (userId == null) {
        throw Exception("❌ User ID tidak ditemukan di local storage.");
      }

      // 🔍 **Filter laporan berdasarkan user ID**
      List<Report> userReports = data
          .map((report) => Report.fromJson(report))
          .where((report) => report.userId == userId)
          .toList();

      debugPrint("✅ Found ${userReports.length} reports for user ID: $userId");

      return userReports;
    } else {
      throw Exception("❌ Gagal mengambil laporan. Status: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("❌ Error fetching user reports: $e");
    return []; // ✅ Jangan crash, return list kosong
  }
}


}
