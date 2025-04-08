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

  @override
  Future<UserEntity> verifyOtp(String email, String code) async {
    final result = await remoteDataSource.verifyEmailOtp(email, code); 
    if (result.containsKey('error')) throw Exception(result['error']);
    return UserModel.fromJson(result['user']);
  }


  @override
  Future<void> resendOtp(String email) async {
    final result = await remoteDataSource.resendOtp(email);
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final result = await remoteDataSource.forgotPassword(email);
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
  }

@override
Future<bool> verifyForgotOtp(String email, String code) async {
  final result = await remoteDataSource.verifyForgotOtp(email, code);
  return result["message"] == "OTP valid. Silakan atur ulang password Anda.";
}

  @override
  Future<void> resetPassword(String email, String newPassword) async {
    final result = await remoteDataSource.resetPassword(email, newPassword);
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
  }

  @override
  Future<void> resendForgotOtp(String email) async {
    final result = await remoteDataSource.resendForgotOtp(email);
    if (result.containsKey('error')) {
      throw Exception(result['error']);
    }
  }


}
