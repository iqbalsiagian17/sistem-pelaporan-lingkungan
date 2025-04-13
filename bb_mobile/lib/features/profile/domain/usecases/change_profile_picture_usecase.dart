import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';

class ChangeProfilePictureUseCase {
  final UserProfileRepository repository;

  ChangeProfilePictureUseCase(this.repository);

  Future<UserEntity> execute(String filePath) {
    return repository.changeProfilePicture(filePath);
  }
}
