import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_all_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_data_state.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_empty_state.dart';
import 'package:bb_mobile/features/report/presentation/widgets/list/report_list_status_filter_sheet.dart';
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
  String _selectedStatus = 'all';

  void _onRetry() {
    ref.read(reportProvider.notifier).fetchReports();
  }

  void _showStatusFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ReportStatusFilterBottomSheet(
        selectedStatus: _selectedStatus,
        onStatusSelected: (newStatus) {
          setState(() => _selectedStatus = newStatus);
        },
      ),
    );
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        break;
      case 2:
        context.go(AppRoutes.createReport);
        break;
      case 3:
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
      appBar: ReportListAllTopBar(
        title: "Semua Laporan",
        onFilterPressed: () => _showStatusFilterSheet(context),
      ),
      body: state.when(
        data: (reports) => reports.isEmpty
            ? ReportListAllEmptyState(onRetry: _onRetry)
            : ReportListDataState(
                reports: reports,
                onRetry: _onRetry,
                selectedStatus: _selectedStatus,
              ),
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
