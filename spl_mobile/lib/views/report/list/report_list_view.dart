import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/bottom_navbar.dart';
import '../../../providers/user_report_provider.dart';
import './components/report_list_topbar.dart';
import './components/report_list_data_state.dart';

class ReportListAllView extends StatefulWidget {
  const ReportListAllView({super.key});

  @override
  State<ReportListAllView> createState() => _ReportListAllViewState();
}

class _ReportListAllViewState extends State<ReportListAllView> {
  int _selectedIndex = 2; // ✅ Index navbar aktif

  // ✅ Fungsi untuk memperbarui data laporan (digunakan untuk onRetry)
  void _retryFetch() {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    reportProvider.fetchReports();
  }

  // ✅ Fungsi Navigasi berdasarkan Index BottomNavbar
  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.myReport);
        break;
      case 2:
        context.go(AppRoutes.allReport);
        break;
      case 3:
        context.go(AppRoutes.saveReport);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ReportListAllTopBar(
        title: "Semua Laporan",
        onSearch: () {
          debugPrint("🔍 Pencarian laporan belum diimplementasi!");
        },
      ),
      body: reportProvider.isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ Loader saat fetch data
          : ReportSaveDataState(
              reports: reportProvider.reports, // ✅ Data laporan dari API
              onRetry: _retryFetch, // ✅ Fungsi untuk refresh data jika gagal
            ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
