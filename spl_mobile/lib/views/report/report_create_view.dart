import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spl_mobile/core/services/auth/global_auth_service.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/widgets/snackbar/snackbar_helper.dart';
import '../../providers/report/report_provider.dart';
import '../../widgets/navbar/bottom_navbar.dart';
import 'components/report_topbar.dart';
import 'components/report_location_toggle.dart';
import 'components/report_text_field.dart';
import 'components/report_upload_buttons.dart';
import 'package:spl_mobile/widgets/wrapper/safe_back_wrapper.dart';


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
  
  List<String> _villages = [];
  bool isVillageLoading = true;


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      showReportGuideTutorial(); // ⬅️ Wajib dipanggil di sini
    });
  }


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
      final refreshed = await globalAuthService.refreshToken();
      if (!refreshed) {
        await globalAuthService.clearAuthData();
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
        SnackbarHelper.showSnackbar(context, "Sesi kamu telah berakhir. Silakan login ulang.", isError: true);
        return;
      }

      // ✅ Jika berhasil refresh, ambil ulang token baru
      final newToken = await globalAuthService.getAccessToken();
      if (newToken == null || newToken.isEmpty) {
        SnackbarHelper.showSnackbar(context, "Gagal mendapatkan token setelah refresh.", isError: true);
        return;
      }
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
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _detailLocationController.clear();
      setState(() {
        attachments.clear();
        isAtLocation = true;
      });
      SnackbarHelper.showSnackbar(context, "Laporan berhasil dikirim!");
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      });
    } else {
      SnackbarHelper.showSnackbar(context, "Gagal mengirim laporan.", isError: true);
    }
  } catch (e) {
    setState(() => isSubmitting = false);
    SnackbarHelper.showSnackbar(context, "Error: $e", isError: true);
  }
}





Future<void> showReportGuideTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenGuide = prefs.getBool('hasSeenReportGuideTutorial') ?? false;

  if (!hasSeenGuide) {
    await Future.delayed(const Duration(milliseconds: 500)); // beri waktu agar UI stabil

    if (context.mounted) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent, // agar bisa pakai Material custom
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          return Material(
            color: Colors.white, // latar putih
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.help_outline_rounded, size: 48, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    "Wajib Membaca!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Sebelum mengirim aduan, silakan baca terlebih dahulu tata cara pelaporan agar aduan kamu valid dan dapat ditindaklanjuti dengan cepat.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(AppRoutes.reportGuide);
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white, // ✅ teks jadi putih
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      child: const Text("Lihat Tata Cara"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await prefs.setBool('hasSeenReportGuideTutorial', true);
    }
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lokasi Kejadian",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      isScrollControlled: true,
                      builder: (context) {
                        final List<String> villages = [
                          "Aekbolon Jae", "Aekbolon Julu", "Baru Ara", "Balige I", "Balige II", "Balige III",
                          "Bonan Dolok I", "Bonan Dolok II", "Bonan Dolok III", "Hinalang Bagasan",
                          "Huta Bulu Mejan", "Huta Dame", "Huta Namora", "Hutagaol Peatalun (Peatalum)",
                          "Longat", "Lumban Bul Bul", "Lumban Dolok Haumabange", "Lumban Gaol",
                          "Lumban Gorat", "Lumban Pea", "Lumban Pea Timur", "Lumban Silintong", "Tambunan Sunge",
                        ];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Pilih Desa/Kelurahan",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: ListView.separated(
                                  itemCount: villages.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = villages[index];
                                    final isSelected = item == _locationController.text;
                                    return ListTile(
                                      title: Text(item, style: const TextStyle(fontSize: 14)),
                                      tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onTap: () => Navigator.pop(context, item),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    if (selected != null) {
                      setState(() => _locationController.text = selected);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        hintText: "Pilih Desa/Kelurahan",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
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
                onPressed: isSubmitting
                    ? null
                    : () async {
                        bool? confirm = await showModalBottomSheet<bool>(
                          context: context,
                          isDismissible: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.red),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Apakah Kamu Yakin Ingin Mengirim Aduan?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Setelah dikirim, aduan tidak dapat diubah atau diedit.\nPastikan semua data sudah benar.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.grey),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text("Ya, Kirim", style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (confirm == true) {
                          _submitReport(); // ⬅️ Kirim jika pengguna yakin
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Aduan", style: TextStyle(color: Colors.white, fontSize: 16)),
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
