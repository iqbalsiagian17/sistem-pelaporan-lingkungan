import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String identifier, String password);
  Future<void> register(String phone, String username, String email, String password);
  Future<bool> refreshToken();
  Future<void> logout();
}
