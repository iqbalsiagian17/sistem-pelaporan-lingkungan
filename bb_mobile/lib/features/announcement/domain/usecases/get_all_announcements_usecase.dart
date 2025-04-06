import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/domain/repositories/announcement_repository.dart';

class GetAllAnnouncementsUseCase {
  final AnnouncementRepository repo;

  GetAllAnnouncementsUseCase({required this.repo});

  Future<List<AnnouncementEntity>> call() async {
    return await repo.fetchAll();
  }
}
