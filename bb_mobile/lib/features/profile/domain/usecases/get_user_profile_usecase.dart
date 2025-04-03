import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserEntity> execute() async {
    return await repository.getUserProfile();
  }
}