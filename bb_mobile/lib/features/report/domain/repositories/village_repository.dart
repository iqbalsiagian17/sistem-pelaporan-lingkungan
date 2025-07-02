import '../entities/village_entity.dart';

abstract class VillageRepository {
  Future<List<VillageEntity>> getVillages();
}
