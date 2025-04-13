import 'package:bb_mobile/features/auth/data/models/user_model.dart';
import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/profile/data/datasources/user_profile_remote_datasource.dart';
import 'package:bb_mobile/features/profile/domain/entities/report_stats_entity.dart';
import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  UserProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserModel> getUserProfile() async {
    return await remoteDatasource.getUserProfile();
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await remoteDatasource.updateUserProfile(data);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await remoteDatasource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<ReportStatsEntity> getReportStatsByUser(int userId) async {
    return await remoteDatasource.getReportStatsByUser(userId);
  }

  @override
  Future<UserEntity> changeProfilePicture(String filePath) async {
    return await remoteDatasource.changeProfilePicture(filePath);
  }

}
