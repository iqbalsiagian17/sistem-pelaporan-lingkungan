import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String identifier, String password);
  Future<void> register(String phone, String username, String email, String password);
  Future<bool> refreshToken();
  Future<void> logout();

  Future<UserEntity> verifyOtp(String email, String code); 
  Future<void> resendOtp(String email);

  Future<void> forgotPassword(String email);
  Future<bool> verifyForgotOtp(String email, String code);
  Future<void> resetPassword(String email, String newPassword);
  Future<void> resendForgotOtp(String email);


}
