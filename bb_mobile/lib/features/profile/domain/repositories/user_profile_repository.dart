import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/profile/domain/entities/report_stats_entity.dart';

abstract class UserProfileRepository {
  /// Ambil data profil pengguna dari server
  Future<UserEntity> getUserProfile();

  /// Update data profil pengguna
  Future<void> updateUserProfile(Map<String, dynamic> data);

  /// Ganti password pengguna
  Future<void> changePassword(String oldPassword, String newPassword);

  Future<ReportStatsEntity> getReportStatsByUser(int userId);

}
