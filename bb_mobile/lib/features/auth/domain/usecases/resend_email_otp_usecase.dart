import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class ResendEmailOtpUseCase {
  final AuthRepository repository;

  ResendEmailOtpUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.resendOtp(email);
  }
}
