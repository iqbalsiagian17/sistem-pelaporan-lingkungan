import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ Import go_router untuk navigasi antar halaman
import '../../../routes/app_routes.dart'; // ✅ Import AppRoutes
import '../../../widgets/bottom_navbar.dart';
import './components/report_list_topbar.dart';
import './components/report_list_data_state.dart';

class ReportListAllView extends StatefulWidget {
  const ReportListAllView({super.key});

  @override
  State<ReportListAllView> createState() => _ReportListAllViewState();
}

class _ReportListAllViewState extends State<ReportListAllView> {
  int _selectedIndex = 2; // ✅ Tetapkan index untuk halaman "Semua Laporan"
  bool isLoading = false;

  // ✅ Data Dummy Laporan
  List<Map<String, dynamic>> savedReports = [
    {
      "image": "assets/images/report/report1.jpg",
      "title": "#Kebocoran PDAM",
      "location": "Balige",
      "time": "11 jam yang lalu",
      "created_at": "2021-08-27 14:00:00",
      "report_number": "ADU-20210827-0001",
      "status": "Disposisi",
      "description": "Laporan mengenai kebocoran pipa PDAM yang mengganggu distribusi air di sekitar Balige.",
      "admin_comments": [
        {
          "status": "Diterima",
          "comment": "Laporan telah diterima, akan segera diproses.",
          "timestamp": "12 Maret 2024 - 10:45 WIB",
        },
        {
          "status": "Diproses",
          "comment": "Dinas terkait telah diberitahu dan dalam perjalanan ke lokasi.",
          "timestamp": "12 Maret 2024 - 11:30 WIB",
        },
        {
          "status": "Disposisi",
          "comment": "Petugas telah melakukan pengecekan awal, tindakan lebih lanjut diperlukan.",
          "timestamp": "12 Maret 2024 - 13:00 WIB",
        },
      ],    
    },
    {
      "image": "assets/images/report/report2.jpg",
      "title": "#Aplikasi Tidak Bermanfaat",
      "location": "Balige",
      "time": "12 jam yang lalu",
      "status": "Selesai",
      "created_at": "2021-08-27 15:00:00",
      "report_number": "ADU-20210827-0002",
      "description": "Keluhan mengenai aplikasi yang dianggap tidak memberikan solusi bagi masyarakat.",
      "admin_comments": [
        {
          "status": "Diterima",
          "comment": "Kami menerima keluhan Anda dan akan melakukan evaluasi.",
          "timestamp": "12 Maret 2024 - 10:00 WIB",
        },
        {
          "status": "Selesai",
          "comment": "Aplikasi telah diperbarui dengan fitur yang lebih bermanfaat.",
          "timestamp": "12 Maret 2024 - 14:30 WIB",
        },
      ],
    },
  ];

  // ✅ Fungsi untuk refresh data laporan
  void _retryFetch() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  // ✅ Fungsi Navigasi berdasarkan Index BottomNavbar
  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return; // ✅ Hindari reload jika di halaman yang sama

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

    setState(() => _selectedIndex = index); // ✅ Update UI saat berpindah halaman
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Pastikan background tetap putih
      appBar: ReportListAllTopBar(
        title: "Semua Laporan",
        onSearch: () {
          debugPrint("Search button clicked!");
          // TODO: Implementasi fitur pencarian laporan
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ Loader saat fetch data
          : ReportSaveDataState(savedReports: savedReports, onRetry: _retryFetch), // ✅ Tampilkan Data
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex, // ✅ Menampilkan tab yang aktif
        onTap: _onNavBarTap, // ✅ Navigasi sesuai dengan index yang ditekan
      ),
    );
  }
}
