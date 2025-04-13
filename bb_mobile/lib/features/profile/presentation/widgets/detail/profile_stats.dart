import 'package:bb_mobile/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileStats extends ConsumerStatefulWidget {
  const ProfileStats({super.key});

  @override
  ConsumerState<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends ConsumerState<ProfileStats> {
  bool _hasFetchedStats = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.when(
        data: (user) {
          if (!_hasFetchedStats) {
            Future.microtask(() {
              ref.read(userProfileProvider.notifier).fetchStats();
            });
            _hasFetchedStats = true;
          }

          final stats = ref.watch(userProfileProvider.notifier).reportStats;

          if (stats == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  label: "Aduan dikirim",
                  value: "${stats.sent}",
                ),
                _divider(),
                _buildStatItem(
                  context,
                  label: "Aduan selesai",
                  value: "${stats.completed}",
                ),
                _divider(),
                _buildStatItem(
                  context,
                  label: "Aduan disimpan",
                  value: "${stats.saved}",
                ),
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("Gagal memuat statistik: $error")),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {required String value, required String label}) {
    return InkWell(
      onTap: () => context.go(AppRoutes.myReport),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1.5,
      color: Colors.black12,
    );
  }
}
