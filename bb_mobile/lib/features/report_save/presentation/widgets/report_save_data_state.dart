import 'package:bb_mobile/features/report_save/domain/entities/report_save_entity.dart';
import 'package:bb_mobile/features/report_save/presentation/widgets/report_save_list_item.dart';
import 'package:bb_mobile/widgets/skeleton/skeleton_report_list.dart';
import 'package:flutter/material.dart';

class ReportSaveDataState extends StatefulWidget {
  final List<ReportSaveEntity> reports;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const ReportSaveDataState({
    super.key,
    required this.reports,
    required this.isLoading,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  State<ReportSaveDataState> createState() => _ReportSaveDataStateState();
}

class _ReportSaveDataStateState extends State<ReportSaveDataState> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
        itemBuilder: (_, __) => const SkeletonReportList(),
      );
    }

    if (widget.errorMessage != null) {
      return Center(child: Text(" ${widget.errorMessage}"));
    }


    final displayedReports =
        _showAll ? widget.reports : widget.reports.take(10).toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedReports.length,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (context, index) {
              final report = displayedReports[index];
              return ReportSaveListItem(
                report: report,
                index: index,
              );
            },
          ),
          if (!_showAll && widget.reports.length > 10)
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
    );
  }
}
