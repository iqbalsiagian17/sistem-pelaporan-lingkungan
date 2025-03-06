import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class ReportUploadButtons extends StatefulWidget {
  final Function(List<File>) onFilesSelected; // ✅ Callback untuk mengirim file ke parent

  const ReportUploadButtons({super.key, required this.onFilesSelected});

  @override
  State<ReportUploadButtons> createState() => _ReportUploadButtonsState();
}

class _ReportUploadButtonsState extends State<ReportUploadButtons> {
  final List<File> _selectedImages = [];

  // ✅ Fungsi untuk memilih banyak gambar dari galeri
  Future<void> _pickMultipleImages() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });

      // ✅ Kirim file ke parent widget agar bisa dikirim ke backend
      widget.onFilesSelected(_selectedImages);
    }
  }

  // ✅ Fungsi untuk mengambil gambar dari kamera
  Future<void> _pickImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();

    bool confirm = await _showCameraOrientationSheet(context);
    if (!confirm) return;

    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });

      // ✅ Kirim file ke parent widget agar bisa dikirim ke backend
      widget.onFilesSelected(_selectedImages);
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
                  const Text(
                    "Gunakan Mode Landscape",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Agar hasil foto lebih optimal, ambillah gambar dalam mode landscape (horizontal).",
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
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Batal", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Lanjut", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  // ✅ Hapus gambar yang sudah dipilih
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });

    // ✅ Kirim file ke parent widget setelah perubahan
    widget.onFilesSelected(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔘 Tombol untuk pilih gambar
        Row(
          children: [
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
            const SizedBox(width: 10),
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
