import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import 'components/report_topbar.dart'; // ✅ Import TopBar
import 'components/report_location_toggle.dart';
import 'components/report_text_field.dart';
import 'components/report_upload_buttons.dart';
import 'components/report_submit_button.dart';

class ReportCreateView extends StatefulWidget {
  const ReportCreateView({super.key});

  @override
  State<ReportCreateView> createState() => _ReportCreateViewState();
}

class _ReportCreateViewState extends State<ReportCreateView> {
  bool isAtLocation = true;
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportTopBar(title: "Isi Aduan"), // ✅ Tambahkan title

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportLocationToggle(
              isAtLocation: isAtLocation,
              onChange: (value) => setState(() => isAtLocation = value),
            ),
            const SizedBox(height: 20),
            const ReportTextField(title: "Judul Aduan", hint: "Masukkan judul laporan"),
            const SizedBox(height: 16),
            const ReportTextField(title: "Rincian Aduan", hint: "Masukkan rincian aduan secara lengkap", maxLines: 5),
            if (!isAtLocation) const ReportTextField(title: "Lokasi Kejadian", hint: "Masukkan Desa/Kelurahan"),
            const SizedBox(height: 16),
            const ReportTextField(title: "Detail Lokasi (Opsional)", hint: "Tambahkan detail lokasi kejadian"),
            const SizedBox(height: 16),
            ReportUploadButtons(isAtLocation: isAtLocation),
            const SizedBox(height: 30),
            const ReportSubmitButton(),
            const SizedBox(height: 10),
          ],
        ),
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
