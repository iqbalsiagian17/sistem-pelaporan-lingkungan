import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/report_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/delete_confirmation_modal.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/report_empty_state.dart';
import 'package:bb_mobile/features/report/presentation/widgets/my_report/report_list_item.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      appBar: const ReportTopBar(title: "Aduanku"), 
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
                      final canDelete = report.status.toLowerCase().trim() == "pending";

                      return InkWell(
                        onTap: () => context.push(AppRoutes.detailReport, extra: report),
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: canDelete ? 32.0 : 0.0), // kasih ruang hanya kalau ada titik 3
                              child: ReportListItem(report: report),
                            ),
                            // HANYA tampilkan titik tiga jika pending
                            if (canDelete)
                            Positioned(
                              top: 4,
                              right: 0,
                              child: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    context.push(AppRoutes.editReport, extra: report);
                                  } else if (value == 'delete') {
                                    await _confirmDelete(context, report.id);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                color: Colors.white,
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, size: 20, color: Colors.black87),
                                        SizedBox(width: 8),
                                        Text("Edit", style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                        SizedBox(width: 8),
                                        Text("Hapus", style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: Icon(Icons.more_vert, size: 22, color: Colors.grey[700]),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  if (!_showAll && userReports.length > 10)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton.icon(
                        onPressed: () => setState(() => _showAll = true),
                        icon: const Icon(Icons.expand_more),
                        label: const Text("Lihat Semua"),
                        style: TextButton.styleFrom(foregroundColor: Color(0xFF66BB6A)),
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


  Future<void> _confirmDelete(BuildContext context, int reportId) async {
  final confirm = await DeleteConfirmationModal.show(context);

  if (confirm == true && context.mounted) {
    final success = await ref.read(reportProvider.notifier).deleteReport(reportId.toString());

    if (success) {
      SnackbarHelper.showSnackbar(
        context,
        "Laporan berhasil dihapus",
      );
      await ref.read(reportProvider.notifier).fetchReports(); // refresh data
    } else {
      SnackbarHelper.showSnackbar(
        context,
        "Gagal menghapus laporan",
        isError: true,
      );
    }
  }

}


}
