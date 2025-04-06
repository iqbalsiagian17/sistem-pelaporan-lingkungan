import 'package:bb_mobile/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AnnouncementEntity>> fetchAll() async {
    final result = await remoteDataSource.fetchAnnouncements();
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AnnouncementEntity> fetchById(int id) async {
    final result = await remoteDataSource.fetchAnnouncementById(id);
    return result.toEntity();
  }
}
