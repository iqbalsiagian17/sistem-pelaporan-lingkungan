import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_all_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_data_state.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_empty_state.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_report_list.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportListAllView extends ConsumerStatefulWidget {
  const ReportListAllView({super.key});
  @override
  ConsumerState<ReportListAllView> createState() => _ReportListAllViewState();
}

class _ReportListAllViewState extends ConsumerState<ReportListAllView> {
  int _selectedIndex = 2;

  void _onRetry() {
    ref.read(reportProvider.notifier).fetchReports();
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        // context.go(AppRoutes.myReport);
        break;
      case 2:
        context.go(AppRoutes.createReport);
        break;
      case 3:
        // context.go(AppRoutes.savedReport);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportListAllTopBar(title: "Semua Laporan"),
      body: state.when(
        data: (reports) => reports.isEmpty
            ? ReportListAllEmptyState(onRetry: _onRetry)
            : ReportListDataState(reports: reports, onRetry: _onRetry),
        loading: () => ListView.builder(
          itemCount: 6,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemBuilder: (_, __) => const SkeletonReportList(),
        ),
        error: (_, __) => ReportListAllEmptyState(onRetry: _onRetry),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
