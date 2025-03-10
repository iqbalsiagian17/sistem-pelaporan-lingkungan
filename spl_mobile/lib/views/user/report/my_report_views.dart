import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _retryFetch() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);

    // ✅ Ambil ID user yang sedang login
    final int? currentUserId = authProvider.user?.id;

    print("User ID yang sedang login: $currentUserId");
    print("Daftar laporan sebelum difilter: ${reportProvider.reports.map((e) => e.toJson()).toList()}");

    // ✅ Filter laporan berdasarkan ID user yang sedang login
    final List<Report> reports = reportProvider.reports
        .where((report) => report is Report && report.userId == currentUserId)
        .cast<Report>() // ✅ Explicitly cast to List<Report>
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportTopBar(title: "Aduanku"),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ReportDataState(reports: reports, onRetry: _retryFetch),
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
