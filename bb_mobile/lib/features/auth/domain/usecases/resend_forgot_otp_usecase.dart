import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class ResendForgotOtpUseCase {
  final AuthRepository repository;

  ResendForgotOtpUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.resendForgotOtp(email);
  }
}
