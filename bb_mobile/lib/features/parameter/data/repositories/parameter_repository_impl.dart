import 'package:bb_mobile/features/parameter/data/datasources/parameter_remote_datasource.dart';
import 'package:bb_mobile/features/parameter/domain/entities/parameter_entity.dart';
import 'package:bb_mobile/features/parameter/domain/repositories/parameter_repository.dart';

class ParameterRepositoryImpl implements ParameterRepository {
  final ParameterRemoteDataSource remoteDataSource;

  ParameterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ParameterEntity> getParameter() async {
    try {
      final model = await remoteDataSource.fetchParameter();
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
