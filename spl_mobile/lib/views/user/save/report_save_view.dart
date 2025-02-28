import 'package:flutter/material.dart';
import '../../../widgets/bottom_navbar.dart';
import './components/report_save_topbar.dart'; // ✅ Import SaveReportTopBar
import './components/report_save_data_state.dart'; // ✅ Import DataState

class ReportSaveView extends StatefulWidget {
  const ReportSaveView({super.key});

  @override
  State<ReportSaveView> createState() => _ReportSaveViewState();
}

class _ReportSaveViewState extends State<ReportSaveView> {
  int _selectedIndex = 3; // ✅ Index untuk menu "Disimpan"
  bool isLoading = false;

  // ✅ Contoh Data Dummy Laporan yang Disimpan
  List<Map<String, String>> savedReports = [
    {
      "image": "assets/images/report/report1.jpg",
      "title": "Ada kebocoran PDAM di Perempatan Jln gajah mada arah ke kh.wahid hasyim...",
      "location": "Balige",
      "time": "11 jam yang lalu",
      "status": "Disposisi",
    },
    {
      "image": "assets/images/report/report2.jpg",
      "title": "Aplikasi Tidak bermanfaat. Saya lapor pengaduan disini Sudah 2 t...",
      "location": "Balige",
      "time": "12 jam yang lalu",
      "status": "Selesai",
    },
  ];

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
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Ensures entire background is white
      appBar: const SaveReportTopBar(title: "Laporan Disimpan"), // ✅ Gunakan top bar dengan gradient hijau

      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ Loader saat fetching data
          : ReportSaveDataState(savedReports: savedReports, onRetry: _retryFetch), // ✅ Tampilkan Data

      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
