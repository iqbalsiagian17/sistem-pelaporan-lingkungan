  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:flutter/services.dart';
  import 'package:spl_mobile/widgets/show_snackbar.dart';

  class ReportUploadButtons extends StatefulWidget {
    final bool isAtLocation; // ✅ Parameter untuk mengetahui apakah user di lokasi
    final Function(List<File>) onFilesSelected; // ✅ Callback untuk mengirim file ke parent
    final Function(double, double) onLocationCaptured; 

    const ReportUploadButtons({
      super.key,
      required this.isAtLocation,
      required this.onFilesSelected,
      required this.onLocationCaptured,
    });

    @override
    State<ReportUploadButtons> createState() => _ReportUploadButtonsState();
  }

  class _ReportUploadButtonsState extends State<ReportUploadButtons> {
    final List<File> _selectedImages = [];
    final Set<String> _imagePaths = {}; // Gunakan Set<String> untuk mencegah duplikasi

    double? latitude;
    double? longitude;


  // ✅ Dapatkan lokasi GPS
  Future<void> _getCurrentLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          latitude = position.latitude.toDouble();
          longitude = position.longitude.toDouble();
        });
        if (latitude != null && longitude != null) {
          widget.onLocationCaptured(latitude!, longitude!);
        }
      } catch (e) {
        debugPrint("Error mendapatkan lokasi: $e");
      }
    }

    @override
    void initState() {
      super.initState();
      if (widget.isAtLocation) {
        _getCurrentLocation();
      }
    }

    
  // ✅ Fungsi untuk memilih banyak gambar dari galeri (tanpa duplikasi & batas 5 gambar)
      void _pickMultipleImages() async {
    if (widget.isAtLocation) return;

    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      final Set<String> newPaths = {}; // Set untuk menyimpan path unik
      final List<File> uniqueFiles = [];

      for (var file in pickedFiles) {
        if (_selectedImages.length >= 5) {
          SnackbarHelper.showSnackbar(context, "Maksimal 5 gambar dapat diunggah!", isError: true);
          break;
        }

        if (_imagePaths.add(file.path) && newPaths.add(file.path)) {
          _selectedImages.add(File(file.path));
          uniqueFiles.add(File(file.path));
        }
      }

      if (uniqueFiles.isNotEmpty) {
        widget.onFilesSelected(uniqueFiles); // Kirim hanya gambar unik
        print("DEBUG: Gambar yang dipilih -> ${uniqueFiles.map((file) => file.path).toList()}");
      }
    }
  }



    // ✅ Fungsi untuk mengambil gambar dari kamera
    Future<void> _pickImageFromCamera(BuildContext context) async {
      if (!widget.isAtLocation) return;

        bool confirm = await _showCameraOrientationSheet(context);
        if (!confirm) return; // Jika user batal, hentikan proses

      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        if (_selectedImages.length >= 5) {
          SnackbarHelper.showSnackbar(context, "Maksimal 5 gambar dapat diunggah!", isError: true);
          return;
        }

        if (_imagePaths.add(pickedFile.path)) { 
          _selectedImages.add(File(pickedFile.path));
          widget.onFilesSelected(List.from(_selectedImages));
        }
      }
    }



    // ✅ Konfirmasi sebelum mengambil foto (agar landscape)
    Future<bool> _showCameraOrientationSheet(BuildContext context) async {
      HapticFeedback.mediumImpact();
      return await showModalBottomSheet<bool>(
            context: context,
            isDismissible: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt_rounded, size: 50, color: Colors.green),
                    const SizedBox(height: 12),
                    const Text("Gunakan Mode Landscape",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text("Agar hasil foto lebih optimal, ambillah gambar dalam mode landscape.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Image.asset("assets/images/camera_orientation.jpg", width: 200),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Batal", style: TextStyle(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Lanjut", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ) ?? false;
    }


    // ✅ Hapus gambar yang sudah dipilih
  // ✅ Hapus gambar yang sudah dipilih
    void _removeImage(int index) {
      setState(() {
        _imagePaths.remove(_selectedImages[index].path);
        _selectedImages.removeAt(index);
      });

      widget.onFilesSelected(List.from(_selectedImages));
    }



    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          // 🔘 Tombol untuk pilih gambar
          Row(
            children: [
              if (!widget.isAtLocation) // ❌ Jika tidak di lokasi, hanya tampil tombol pilih gambar
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickMultipleImages,
                    icon: const Icon(Icons.image, color: Color.fromRGBO(76, 175, 80, 1)),
                    label: const Text(
                      "Pilih Gambar",
                      style: TextStyle(color: Color.fromRGBO(76, 175, 80, 1)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color.fromRGBO(76, 175, 80, 1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

              if (widget.isAtLocation) // ✅ Jika di lokasi, hanya tampil tombol ambil foto
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImageFromCamera(context),
                    icon: const Icon(Icons.camera_alt, color: Color.fromRGBO(76, 175, 80, 1)),
                    label: const Text(
                      "Ambil Foto",
                      style: TextStyle(color: Color.fromRGBO(76, 175, 80, 1)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color.fromRGBO(76, 175, 80, 1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // 📂 Tampilkan gambar yang sudah dipilih
          if (_selectedImages.isNotEmpty) ...[
            const Text(
              "Gambar yang dipilih:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImages[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      );
    }
  }
