import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import '../../providers/user_report_provider.dart';
import '../../widgets/bottom_navbar.dart';
import 'components/report_topbar.dart';
import 'components/report_location_toggle.dart';
import 'components/report_text_field.dart';
import 'components/report_upload_buttons.dart';

class ReportCreateView extends StatefulWidget {
  const ReportCreateView({super.key});

  @override
  State<ReportCreateView> createState() => _ReportCreateViewState();
}

class _ReportCreateViewState extends State<ReportCreateView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailLocationController = TextEditingController();

  bool isAtLocation = true;
  int _selectedIndex = 2;
  bool isSubmitting = false;
  List<File> attachments = []; // ✅ List untuk menyimpan gambar yang dipilih

  Future<void> _submitReport() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Judul dan rincian aduan wajib diisi!")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // ✅ Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        throw Exception("❌ Tidak ada token. Silakan login ulang.");
      }

      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      bool success = await reportProvider.createReport(
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateTime.now().toIso8601String(),
        locationDetails: isAtLocation ? _detailLocationController.text : null,
        village: !isAtLocation ? _locationController.text : null,
        latitude: isAtLocation ? "0.0" : null,
        longitude: isAtLocation ? "0.0" : null,
        isAtLocation: isAtLocation,
        attachments: attachments, // ✅ Kirim gambar ke backend
      );

      setState(() => isSubmitting = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Laporan berhasil dikirim!")),
        );

        // 🚀 **Tunggu 500ms, lalu navigasi ke halaman Home**
        Future.delayed(Duration(seconds: 1), () {
          if (context.mounted) {
            context.go(AppRoutes.home);
          }
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Gagal mengirim laporan.")),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportTopBar(title: "Isi Aduan"),
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
            ReportTextField(controller: _titleController, title: "Judul Aduan", hint: "Masukkan judul laporan"),
            const SizedBox(height: 16),
            ReportTextField(
              controller: _descriptionController,
              title: "Rincian Aduan",
              hint: "Masukkan rincian aduan secara lengkap",
              maxLines: 5,
            ),
            if (!isAtLocation)
              ReportTextField(controller: _locationController, title: "Lokasi Kejadian", hint: "Masukkan Desa/Kelurahan"),
            const SizedBox(height: 16),
            ReportTextField(controller: _detailLocationController, title: "Detail Lokasi (Opsional)", hint: "Tambahkan detail lokasi kejadian"),
            const SizedBox(height: 16),
            
            // ✅ Perbaikan pemanggilan ReportUploadButtons tanpa isAtLocation
            ReportUploadButtons(
              onFilesSelected: (files) {
                setState(() {
                  attachments = files;
                });
              },
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Aduan", style: TextStyle(color: Colors.white)),
              ),
            ),
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
