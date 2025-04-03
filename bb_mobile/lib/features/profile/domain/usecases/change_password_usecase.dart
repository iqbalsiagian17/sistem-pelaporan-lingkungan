import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';

class ChangePasswordUseCase {
  final UserProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> execute(String oldPassword, String newPassword) async {
    await repository.changePassword(oldPassword, newPassword);
  }
}