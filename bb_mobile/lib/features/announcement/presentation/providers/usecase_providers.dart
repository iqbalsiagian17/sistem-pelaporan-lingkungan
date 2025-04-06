import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:bb_mobile/features/announcement/data/repositories/announcement_repository_impl.dart';
import 'package:bb_mobile/features/announcement/domain/usecases/get_all_announcements_usecase.dart';
import 'package:bb_mobile/features/announcement/domain/usecases/get_announcement_detail_usecase.dart';

// Remote datasource
final announcementRemoteDataSourceProvider = Provider<AnnouncementRemoteDataSource>((ref) {
  return AnnouncementRemoteDataSourceImpl(DioClient.instance);
});

// Repository
final announcementRepositoryProvider = Provider<AnnouncementRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(announcementRemoteDataSourceProvider);
  return AnnouncementRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Usecases
final getAllAnnouncementsUseCaseProvider = Provider<GetAllAnnouncementsUseCase>((ref) {
  final repo = ref.watch(announcementRepositoryProvider);
  return GetAllAnnouncementsUseCase(repo: repo);
});

final getAnnouncementDetailUseCaseProvider = Provider<GetAnnouncementDetailUseCase>((ref) {
  final repo = ref.watch(announcementRepositoryProvider);
  return GetAnnouncementDetailUseCase(repo: repo);
});
