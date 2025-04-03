import 'package:dio/dio.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/auth/data/models/user_model.dart';
import 'package:bb_mobile/features/profile/data/models/report_stats_model.dart';

abstract class ProfileRemoteDatasource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(Map<String, dynamic> data);
  Future<bool> changePassword(String oldPassword, String newPassword);
  Future<ReportStatsModel> getReportStatsByUser(int userId);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio _dio = DioClient.instance;

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get("${ApiConstants.userProfileBaseUrl}/");
      final data = response.data['data'];
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Gagal mengambil data profil");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil data profil.");
    }
  }

  @override
  Future<UserModel> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put("${ApiConstants.userProfileBaseUrl}/update", data: data);
      final updatedData = response.data['data'];
      return UserModel.fromJson(updatedData);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Gagal memperbarui profil");
    }
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      await _dio.put(
        "${ApiConstants.userProfileBaseUrl}/change-password",
        data: {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
      );
      return true;
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Gagal mengubah password");
    }
  }

  @override
  Future<ReportStatsModel> getReportStatsByUser(int userId) async {
    try {
      final response = await _dio.get("${ApiConstants.userReportUrl}/$userId/report-stats");
      final data = response.data['data'];
      return ReportStatsModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Gagal mengambil statistik laporan");
    }
  }
}
