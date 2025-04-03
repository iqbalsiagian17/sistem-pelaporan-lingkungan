import 'package:bb_mobile/features/profile/domain/entities/report_stats_entity.dart';
import 'package:bb_mobile/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';

class GetReportStatsUseCase {
  final UserProfileRepository repository;

  GetReportStatsUseCase(this.repository);

  Future<ReportStatsEntity> execute() async {
    final userId = await globalAuthService.getUserId();
    if (userId == null) {
      throw Exception("User belum login.");
    }
    return repository.getReportStatsByUser(userId);
  }
}
