import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailOtpUseCase {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  Future<UserEntity> execute(String email, String code) {
    return repository.verifyOtp(email, code); // ✅ return data user
  }
}
