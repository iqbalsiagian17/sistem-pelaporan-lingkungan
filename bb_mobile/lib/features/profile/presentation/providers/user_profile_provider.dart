import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/profile/domain/entities/report_stats_entity.dart';
import 'package:bb_mobile/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/change_profile_picture_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/get_report_stats_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:bb_mobile/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:bb_mobile/features/profile/presentation/providers/usecase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserEntity>>((ref) {
  return UserProfileNotifier(
    ref.read(getUserProfileUsecaseProvider),
    ref.read(updateUserProfileUsecaseProvider),
    ref.read(changePasswordUsecaseProvider),
    ref.read(getReportStatsUsecaseProvider),
    ref.read(changeProfilePictureUsecaseProvider),
  );
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserEntity>> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final GetReportStatsUseCase _getReportStatsUseCase;
  final ChangeProfilePictureUseCase _changeProfilePictureUseCase;


  ReportStatsEntity? _reportStats;
  bool _isStatsLoading = false;

  UserProfileNotifier(
    this._getUserProfileUseCase,
    this._updateUserProfileUseCase,
    this._changePasswordUseCase,
    this._getReportStatsUseCase,
    this._changeProfilePictureUseCase,
  ) : super(const AsyncLoading()) {
    loadUserProfile();
    fetchStats();
  }

  ReportStatsEntity? get reportStats => _reportStats;
  bool get isStatsLoading => _isStatsLoading;


  Future<void> loadUserProfile() async {
    try {
      state = const AsyncLoading();
      final user = await _getUserProfileUseCase.execute();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      await _updateUserProfileUseCase.execute(data);
      await loadUserProfile();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      await _changePasswordUseCase.execute(oldPassword, newPassword);
      return true;
    } catch (_) {
      return false;
    }
  }

   Future<void> fetchStats() async {
    _isStatsLoading = true;
    try {
      _reportStats = await _getReportStatsUseCase.execute();
    } catch (_) {
      _reportStats = null;
    } finally {
      _isStatsLoading = false;
    }
  }

 Future<bool> changeProfilePicture(String filePath) async {
  try {
    await _changeProfilePictureUseCase.execute(filePath);
    await loadUserProfile(); // ✅ Refresh profil dari server
    return true;
  } catch (_) {
    return false;
  }
}
}
