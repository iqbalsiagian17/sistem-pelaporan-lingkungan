import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bb_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bb_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:bb_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:bb_mobile/features/auth/domain/usecases/refresh_token_usecase.dart';

// ✅ Provider untuk RemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = DioClient.instance;
  return AuthRemoteDataSourceImpl(dio);
});

// ✅ Provider untuk Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// ✅ Provider untuk UseCases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  return RefreshTokenUseCase(ref.read(authRepositoryProvider));
});
