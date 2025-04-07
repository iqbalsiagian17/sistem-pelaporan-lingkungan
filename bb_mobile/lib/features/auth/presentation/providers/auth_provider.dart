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


  return AuthNotifier(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    refreshTokenUseCase: refreshUseCase,
    verifyEmailOtpUseCase: verifyOtpUseCase,
    resendEmailOtpUseCase: resendOtpUseCase,

  );
});
