import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/widgets/show_snackbar.dart';
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

  double? latitude;  // ✅ Deklarasikan variabel latitude
  double? longitude; // ✅ Deklarasikan variabel longitude

  Future<void> _submitReport() async {
  if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
    SnackbarHelper.showSnackbar(context, "Judul dan rincian aduan wajib diisi!", isError: true);
    return;
  }

  if (!isAtLocation && _locationController.text.isEmpty) {
    SnackbarHelper.showSnackbar(context, "Lokasi kejadian (Desa/Kelurahan) wajib diisi!", isError: true);
    return;
  }

  if (attachments.isEmpty) {
    SnackbarHelper.showSnackbar(context, "Minimal 1 gambar harus diunggah!", isError: true);
    return;
  }

  if (attachments.length > 5) {
    SnackbarHelper.showSnackbar(context, "Maksimal 5 gambar dapat diunggah!", isError: true);
    return;
  }

  setState(() => isSubmitting = true);

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      throw Exception("❌ Tidak ada token. Silakan login ulang.");
    }

    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    // ✅ Cek apakah user masih memiliki laporan yang belum selesai
if (reportProvider.hasPendingReports(prefs.getInt("id") ?? 0)) {
      setState(() => isSubmitting = false);
      SnackbarHelper.showSnackbar(
        context,
        "Anda masih memiliki laporan yang belum selesai'.",
        isError: true,
      );
      return;
    }

    // ✅ Hanya kirim gambar unik
    final Set<String> uniquePaths = {};
    final List<File> uniqueFiles = attachments.where((file) {
      return uniquePaths.add(file.path);
    }).toList();
print("📌 [DEBUG] Location Details: '${_detailLocationController.text}'");


bool success = await reportProvider.createReport(
  title: _titleController.text,
  description: _descriptionController.text,
  date: DateTime.now().toIso8601String(),
  locationDetails: (_detailLocationController.text.isNotEmpty)
      ? _detailLocationController.text
      : "Tidak ada detail lokasi", // ✅ Pastikan tetap dikirim sebagai string
  village: !isAtLocation ? _locationController.text : null,
  latitude: isAtLocation ? latitude?.toString() ?? "0.0" : null,
  longitude: isAtLocation ? longitude?.toString() ?? "0.0" : null,
  isAtLocation: isAtLocation,
  attachments: uniqueFiles,
);



    setState(() => isSubmitting = false);

    if (success) {
      SnackbarHelper.showSnackbar(context, "✅ Laporan berhasil dikirim!");
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      });
    } else {
      SnackbarHelper.showSnackbar(context, "❌ Gagal mengirim laporan.", isError: true);
    }
  } catch (e) {
    setState(() => isSubmitting = false);
    SnackbarHelper.showSnackbar(context, "⚠️ Error: $e", isError: true);
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
            
 // ✅ Pastikan ReportUploadButtons mengirim koordinat ke ReportCreateView
ReportUploadButtons(
  isAtLocation: isAtLocation,
  onFilesSelected: (files) {
    setState(() {
      final Set<String> uniquePaths = {};
      List<File> uniqueFiles = [];

      for (var file in files) {
        if (uniquePaths.add(file.path)) { 
          uniqueFiles.add(file);
        }
      }

      attachments = uniqueFiles; // Pastikan hanya menyimpan gambar unik
    });

print("DEBUG: Jumlah gambar yang dikirim ke API -> ${attachments.length}");
print("DEBUG: Paths gambar yang dikirim -> ${attachments.map((file) => file.path).toList()}");
  },
  onLocationCaptured: (lat, long) {
    setState(() {
      latitude = lat;
      longitude = long;
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
