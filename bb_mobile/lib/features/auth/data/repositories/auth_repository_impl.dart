import 'package:bb_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bb_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:bb_mobile/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String identifier, String password) async {
    final result = await remoteDataSource.login(identifier, password);
    
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }

    final user = result['user'];
    if (user == null) throw Exception("User tidak ditemukan.");

    return UserModel.fromJson(user); // extend UserEntity
  }

  @override
  Future<void> register(String phone, String username, String email, String password) async {
    final result = await remoteDataSource.register(phone, username, email, password);
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
  }

  @override
  Future<bool> refreshToken() {
    return remoteDataSource.refreshToken();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
