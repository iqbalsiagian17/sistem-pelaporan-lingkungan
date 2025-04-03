import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(String phone, String username, String email, String password) {
    return repository.register(phone, username, email, password);
  }
}
