import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/auth/domain/usecases/resend_email_otp_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/verify_email_otp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  final ResendEmailOtpUseCase resendEmailOtpUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.refreshTokenUseCase,
    required this.verifyEmailOtpUseCase,
    required this.resendEmailOtpUseCase,


  }) : super(const AsyncValue.data(null)) {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefsUserId = await globalAuthService.getUserId();
    if (prefsUserId != null) {
      final username = await globalAuthService.getUsername();
      final email = await globalAuthService.getEmail();
      final phone = await globalAuthService.getPhoneNumber();
      final type = await globalAuthService.getUserType();
      final authProvider = await globalAuthService.getAuthProvider();

      state = AsyncValue.data(UserEntity(
        id: prefsUserId,
        username: username ?? '',
        email: email ?? '',
        phoneNumber: phone ?? '',
        type: type ?? 0,
        authProvider: authProvider ?? 'manual',
      ));
    }
  }


  Future<bool> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await loginUseCase.execute(identifier, password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> register(
      String phone, String username, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await registerUseCase.execute(phone, username, email, password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await globalAuthService.clearAuthData();
    state = const AsyncValue.data(null);
  }

  Future<bool> refreshToken() async {
    return await refreshTokenUseCase.execute();
  }

  Future<bool> verifyOtp(String email, String code) async {
    state = const AsyncValue.loading();
    try {
      final user = await verifyEmailOtpUseCase.execute(email, code);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> resendOtp(String email) async {
    try {
      await resendEmailOtpUseCase.execute(email);
      return true;
    } catch (e) {
      return false;
    }
  }

}
