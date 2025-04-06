import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/domain/repositories/announcement_repository.dart';

class GetAnnouncementDetailUseCase {
  final AnnouncementRepository repo;

  GetAnnouncementDetailUseCase({required this.repo});

  Future<AnnouncementEntity> call(int id) async {
    return await repo.fetchById(id);
  }
}
