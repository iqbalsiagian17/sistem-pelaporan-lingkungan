import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> execute(Map<String, dynamic> data) async {
    await repository.updateUserProfile(data);
  }
}