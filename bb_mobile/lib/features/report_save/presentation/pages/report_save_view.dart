import 'package:bb_mobile/features/report_save/presentation/providers/report_save_provider.dart';
import 'package:bb_mobile/features/report_save/presentation/widgets/report_save_data_state.dart';
import 'package:bb_mobile/features/report_save/presentation/widgets/report_save_empty_state.dart';
import 'package:bb_mobile/features/report_save/presentation/widgets/report_save_topbar.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportSaveView extends ConsumerStatefulWidget {
  const ReportSaveView({super.key});

  @override
  ConsumerState<ReportSaveView> createState() => _ReportSaveViewState();
}

class _ReportSaveViewState extends ConsumerState<ReportSaveView> {
  int _selectedIndex = 3;
  bool _isLoading = false;

  void _retryFetch() async {
    setState(() => _isLoading = true);
    await ref.read(reportSaveNotifierProvider.notifier).fetchSavedReports();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reportSaveNotifierProvider.notifier).fetchSavedReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportSaveNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SaveReportTopBar(title: "Laporan Disimpan"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : reportState.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const ReportSaveEmptyState(); // ✅ tampilkan empty state
                }
                return ReportSaveDataState(
                  reports: reports,
                  isLoading: false,
                  errorMessage: null,
                  onRetry: _retryFetch,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ReportSaveDataState(
                reports: const [],
                isLoading: false,
                errorMessage: err.toString(),
                onRetry: _retryFetch,
              ),
            ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
