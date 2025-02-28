import 'package:flutter/material.dart';
import '../../../widgets/bottom_navbar.dart';
import 'components/report_top_bar.dart';
import 'components/report_data_state.dart';

class MyReportView extends StatefulWidget {
  const MyReportView({super.key});

  @override
  State<MyReportView> createState() => _MyReportViewState();
}

class _MyReportViewState extends State<MyReportView> {
  int _selectedIndex = 1;
  bool isLoading = false;

  // ✅ Contoh Data Dummy (Langsung Ditampilkan)
  List<Map<String, String>> reports = [
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
      "status": "Disposisi",
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
      appBar: const ReportTopBar(title: "Aduanku"), // ✅ Gradient top bar

      body: Container(
        color: Colors.white, // ✅ Forces white background behind the list
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // ✅ Loader while fetching data
            : ReportDataState(reports: reports, onRetry: _retryFetch), // ✅ Displays reports
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
