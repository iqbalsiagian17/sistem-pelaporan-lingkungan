import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';

class VerifyForgotOtpUseCase {
  final AuthRepository repository;

  VerifyForgotOtpUseCase(this.repository);

  Future<bool> execute(String email, String code) async {
    return await repository.verifyForgotOtp(email, code);
  }
}
