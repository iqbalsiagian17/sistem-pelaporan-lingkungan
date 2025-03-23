import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_report_list.dart';
import '../../../widgets/bottom_navbar.dart';
import 'components/report_top_bar.dart';
import 'components/report_data_state.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_report_provider.dart';
import '../../../models/Report.dart'; // ✅ Import model Report

class MyReportView extends StatefulWidget {
  const MyReportView({super.key});

  @override
  State<MyReportView> createState() => _MyReportViewState();
}

class _MyReportViewState extends State<MyReportView> {
  int _selectedIndex = 1;
  bool isLoading = false;

  @override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final reportProvider = Provider.of<ReportProvider>(context);

  final int? currentUserId = authProvider.user?.id;

  final List<Report> reports = reportProvider.reports
      .where((report) => report.userId == currentUserId)
      .toList();

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: const ReportTopBar(title: "Aduanku"),
    body: Container(
      color: Colors.white,
      child: reportProvider.isLoading
          ? ListView.builder(
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (_, __) => const SkeletonReportList(),
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : ReportDataState(reports: reports)
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
