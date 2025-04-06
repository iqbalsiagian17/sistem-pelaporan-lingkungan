import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/announcement/data/models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> fetchAnnouncements();
  Future<AnnouncementModel> fetchAnnouncementById(int id);
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final Dio dio;

  AnnouncementRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final response = await dio.get(ApiConstants.publicAnnouncement);
      final data = response.data['announcements'] as List;
      return data.map((e) => AnnouncementModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data announcement: $e");
    }
  }

  @override
  Future<AnnouncementModel> fetchAnnouncementById(int id) async {
    try {
      final response = await dio.get("${ApiConstants.publicAnnouncement}/$id");
      final data = response.data['announcement'];
      return AnnouncementModel.fromJson(data);
    } catch (e) {
      throw Exception("Gagal mengambil detail announcement: $e");
    }
  }
}
