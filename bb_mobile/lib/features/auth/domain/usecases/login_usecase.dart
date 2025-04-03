import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> execute(String identifier, String password) {
    return repository.login(identifier, password);
  }
}
