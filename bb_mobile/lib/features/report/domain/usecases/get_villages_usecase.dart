import '../entities/village_entity.dart';
import '../repositories/village_repository.dart';

class GetVillagesUseCase {
  final VillageRepository repository;

  GetVillagesUseCase(this.repository);

  Future<List<VillageEntity>> execute() {
    return repository.getVillages();
  }
}
