import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/report_empty_state.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/report_list_item.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReportView extends ConsumerStatefulWidget {
  const MyReportView({super.key});

  @override
  ConsumerState<MyReportView> createState() => _MyReportViewState();
}

class _MyReportViewState extends ConsumerState<MyReportView> {
  int _selectedIndex = 1;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final state = ref.read(reportProvider);
      final hasData = state is AsyncData && state.value != null;

      if (!hasData) {
        ref.read(reportProvider.notifier).fetchReports();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportProvider);
    final currentUserId = globalAuthService.userId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Aduanku"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Terjadi kesalahan: $err")),
        data: (reports) {
          final userReports = reports
              .where((report) => report.userId == currentUserId)
              .toList();

          final displayReports =
              _showAll ? userReports : userReports.take(10).toList();

          if (userReports.isEmpty) return const ReportEmptyState();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(reportProvider.notifier).fetchReports();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayReports.length,
                    itemBuilder: (context, index) {
                      final report = displayReports[index];
                      return ReportListItem(report: report);
                    },
                  ),
                  if (!_showAll && userReports.length > 10)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton.icon(
                        onPressed: () => setState(() => _showAll = true),
                        icon: const Icon(Icons.expand_more),
                        label: const Text("Lihat Semua"),
                        style: TextButton.styleFrom(foregroundColor: Colors.green),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
