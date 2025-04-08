import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/auth/presentation/providers/usecase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/auth/presentation/providers/auth_notifier.dart';

// Provider Auth StateNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final registerUseCase = ref.read(registerUseCaseProvider);
  final refreshUseCase = ref.read(refreshTokenUseCaseProvider);
  final verifyOtpUseCase = ref.read(verifyEmailOtpUseCaseProvider);
  final resendOtpUseCase = ref.read(resendEmailOtpUseCaseProvider);
  final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
  final verifyForgotOtpUseCase = ref.read(verifyForgotOtpUseCaseProvider);
  final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
  final resendForgotOtpUseCase = ref.read(resendForgotOtpUseCaseProvider);

  




  return AuthNotifier(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    refreshTokenUseCase: refreshUseCase,
    verifyEmailOtpUseCase: verifyOtpUseCase,
    resendEmailOtpUseCase: resendOtpUseCase,
    forgotPasswordUseCase: forgotPasswordUseCase,
    verifyForgotOtpUseCase: verifyForgotOtpUseCase,
    resetPasswordUseCase: resetPasswordUseCase,
    resendForgotOtpUseCase: resendForgotOtpUseCase,
    


  );
});
