import 'package:dio/dio.dart';
import 'package:spl_mobile/core/constants/api.dart';
import '../../../models/Announcement.dart';

class AnnouncementService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.publicAnnouncement,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// 🔹 Ambil semua announcement
  Future<List<AnnouncementItem>> fetchAnnouncement() async {
    try {
      final response = await _dio.get("");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['announcements'];
        return data.map((json) => AnnouncementItem.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil data announcement.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  /// 🔹 Ambil detail announcement berdasarkan ID
  Future<AnnouncementItem> fetchAnnouncementById(int id) async {
    try {
      final response = await _dio.get("/$id");

      if (response.statusCode == 200) {
        final data = response.data['announcement'];
        return AnnouncementItem.fromJson(data);
      } else {
        throw Exception("Gagal mengambil detail announcement.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil detail: $e");
    }
  }
}
