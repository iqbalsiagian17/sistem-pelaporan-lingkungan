import 'package:bb_mobile/features/parameter/data/datasources/parameter_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:bb_mobile/features/parameter/data/models/parameter_model.dart';

// Provider Dio instance
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider untuk data source
final parameterRemoteDataSourceProvider = Provider<ParameterRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ParameterRemoteDataSourceImpl(dio);
});

// Provider async untuk fetch parameter
final parameterProvider = FutureProvider<ParameterItem>((ref) async {
  final dataSource = ref.watch(parameterRemoteDataSourceProvider);
  final result = await dataSource.fetchParameter();
  return result;
});
