import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.forgotPassword(email);
  }
}
