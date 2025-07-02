import 'package:bb_mobile/features/report/data/datasources/village_remote_datasource.dart';
import 'package:bb_mobile/features/report/domain/entities/village_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/village_repository.dart';

class VillageRepositoryImpl implements VillageRepository {
  final VillageRemoteDataSource remoteDataSource;

  VillageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VillageEntity>> getVillages() async {
    final models = await remoteDataSource.getAllVillages();
    return models.map((e) => VillageEntity(id: e.id, name: e.name)).toList();
  }
}
