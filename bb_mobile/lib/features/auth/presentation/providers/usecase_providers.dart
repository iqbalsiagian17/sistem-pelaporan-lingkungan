import 'package:bb_mobile/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/resend_email_otp_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/resend_forgot_otp_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/verify_email_otp_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/verify_forgot_otp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bb_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:bb_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/refresh_token_usecase.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = DioClient.instance;
  return AuthRemoteDataSourceImpl(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  return RefreshTokenUseCase(ref.read(authRepositoryProvider));
});

final verifyEmailOtpUseCaseProvider = Provider<VerifyEmailOtpUseCase>((ref) {
  return VerifyEmailOtpUseCase(ref.read(authRepositoryProvider));
});

final resendEmailOtpUseCaseProvider = Provider<ResendEmailOtpUseCase>((ref) {
  return ResendEmailOtpUseCase(ref.read(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.read(authRepositoryProvider));
});

final verifyForgotOtpUseCaseProvider = Provider<VerifyForgotOtpUseCase>((ref) {
  return VerifyForgotOtpUseCase(ref.read(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.read(authRepositoryProvider));
});

final resendForgotOtpUseCaseProvider = Provider<ResendForgotOtpUseCase>((ref) {
  return ResendForgotOtpUseCase(ref.read(authRepositoryProvider));
});
