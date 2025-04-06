import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/domain/usecases/get_parameter_usecase.dart';
import 'package:bb_mobile/features/parameter/data/datasources/parameter_remote_datasource.dart';
import 'package:bb_mobile/features/parameter/data/repositories/parameter_repository_impl.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(); // atau DioClient.instance jika kamu punya custom interceptor
});

final parameterRemoteDataSourceProvider = Provider<ParameterRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ParameterRemoteDataSourceImpl(dio);
});

final parameterRepositoryProvider = Provider<ParameterRepositoryImpl>((ref) {
  final remoteDataSource = ref.read(parameterRemoteDataSourceProvider);
  return ParameterRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getParameterUseCaseProvider = Provider<GetParameterUseCase>((ref) {
  final repository = ref.read(parameterRepositoryProvider);
  return GetParameterUseCase(repository: repository);
});
