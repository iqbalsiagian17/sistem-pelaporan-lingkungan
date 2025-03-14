import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/report_save_provider.dart';
import '../../../widgets/bottom_navbar.dart';
import './components/report_save_topbar.dart';
import './components/report_save_data_state.dart';

class ReportSaveView extends StatefulWidget {
  const ReportSaveView({super.key});

  @override
  State<ReportSaveView> createState() => _ReportSaveViewState();
}

class _ReportSaveViewState extends State<ReportSaveView> {
  int _selectedIndex = 3; // ✅ Index untuk menu "Disimpan"
  bool isLoading = false;

  void _retryFetch() {
    setState(() => isLoading = true);
    Provider.of<ReportSaveProvider>(context, listen: false).fetchSavedReports().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ReportSaveProvider>(context, listen: false).fetchSavedReports());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SaveReportTopBar(title: "Laporan Disimpan"),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReportSaveDataState(onRetry: _retryFetch), // ✅ Berikan `onRetry`

      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
