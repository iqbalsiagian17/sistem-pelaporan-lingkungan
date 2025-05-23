import 'package:bb_mobile/features/profile/domain/usecases/change_profile_picture_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/get_report_stats_usecase.dart' show GetReportStatsUseCase;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bb_mobile/features/profile/data/datasources/user_profile_remote_datasource.dart';
import 'package:bb_mobile/features/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:bb_mobile/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/update_user_profile_usecase.dart';

final userProfileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasourceImpl();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final datasource = ref.read(userProfileRemoteDatasourceProvider);
  return UserProfileRepositoryImpl(datasource);
});

final getUserProfileUsecaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repo = ref.read(userProfileRepositoryProvider);
  return GetUserProfileUseCase(repo);
});

final updateUserProfileUsecaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final repo = ref.read(userProfileRepositoryProvider);
  return UpdateUserProfileUseCase(repo);
});

final changePasswordUsecaseProvider = Provider<ChangePasswordUseCase>((ref) {
  final repo = ref.read(userProfileRepositoryProvider);
  return ChangePasswordUseCase(repo);
});

final getReportStatsUsecaseProvider = Provider<GetReportStatsUseCase>((ref) {
  final repo = ref.read(userProfileRepositoryProvider);
  return GetReportStatsUseCase(repo);
});

final changeProfilePictureUsecaseProvider = Provider<ChangeProfilePictureUseCase>((ref) {
  final repo = ref.read(userProfileRepositoryProvider);
  return ChangeProfilePictureUseCase(repo);
});
