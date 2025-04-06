import 'package:bb_mobile/features/announcement/domain/usecases/get_all_announcements_usecase.dart';
import 'package:bb_mobile/features/announcement/domain/usecases/get_announcement_detail_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/announcement/domain/entities/announcement_entity.dart';
import 'package:bb_mobile/features/announcement/presentation/providers/usecase_providers.dart';

final announcementProvider = StateNotifierProvider<AnnouncementNotifier, AsyncValue<List<AnnouncementEntity>>>(
  (ref) => AnnouncementNotifier(ref.read(getAllAnnouncementsUseCaseProvider)),
);

final announcementDetailProvider = StateNotifierProvider.family<AnnouncementDetailNotifier, AsyncValue<AnnouncementEntity>, int>(
  (ref, id) => AnnouncementDetailNotifier(ref.read(getAnnouncementDetailUseCaseProvider), id),
);

class AnnouncementNotifier extends StateNotifier<AsyncValue<List<AnnouncementEntity>>> {
  final GetAllAnnouncementsUseCase getAllAnnouncementsUseCase;

  AnnouncementNotifier(this.getAllAnnouncementsUseCase) : super(const AsyncLoading()) {
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      final data = await getAllAnnouncementsUseCase();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool hasNewAnnouncement() {
    final now = DateTime.now();
    return state.when(
      data: (announcements) => announcements.any((a) => now.difference(a.createdAt).inHours < 24),
      loading: () => false,
      error: (_, __) => false,
    );
  }
}

class AnnouncementDetailNotifier extends StateNotifier<AsyncValue<AnnouncementEntity>> {
  final GetAnnouncementDetailUseCase getAnnouncementDetailUseCase;
  final int id;

  AnnouncementDetailNotifier(this.getAnnouncementDetailUseCase, this.id)
      : super(const AsyncLoading()) {
    fetchAnnouncementDetail();
  }

  Future<void> fetchAnnouncementDetail() async {
    try {
      final detail = await getAnnouncementDetailUseCase(id);
      state = AsyncValue.data(detail);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
