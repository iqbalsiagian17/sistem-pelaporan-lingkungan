import 'dart:async';
import 'dart:io';
import 'package:bb_mobile/core/utils/location_validator.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class ReportUploadButtons extends StatefulWidget {
  final bool isAtLocation;
  final Function(List<File>) onFilesSelected;
  final Function(double, double) onLocationCaptured;

  // ✅ Tambahan: untuk kirim status valid/invalid lokasi ke luar
  final ValueChanged<bool>? onLocationValidityChanged;

  const ReportUploadButtons({
    super.key,
    required this.isAtLocation,
    required this.onFilesSelected,
    required this.onLocationCaptured,
    this.onLocationValidityChanged,
  });

  @override
  State<ReportUploadButtons> createState() => _ReportUploadButtonsState();
}

class _ReportUploadButtonsState extends State<ReportUploadButtons> {
  final List<File> _selectedImages = [];
  final Set<String> _imagePaths = {};

  double? latitude;
  double? longitude;

  bool _hasShownOutOfAreaSnackbar = false;

  @override
  void initState() {
    super.initState();
    if (widget.isAtLocation) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      double lat = position.latitude;
      double lon = position.longitude;

      debugPrint("📍 Lokasi Saat Ini → lat: $lat, lon: $lon");

      if (!mounted) return;

      bool isInside = LocationValidator.isInsideBaligeArea(lat, lon);
      if (!isInside) {
        if (!_hasShownOutOfAreaSnackbar) {
          SnackbarHelper.showSnackbar(
            context,
            "Anda berada di luar wilayah pelaporan (Kecamatan Balige).",
            isError: true,
          );
          _hasShownOutOfAreaSnackbar = true;
        }
        widget.onLocationValidityChanged?.call(false);
        return;
      }

      setState(() {
        latitude = lat;
        longitude = lon;
      });

      widget.onLocationCaptured(latitude!, longitude!);
      widget.onLocationValidityChanged?.call(true);

    } on TimeoutException {
      if (!mounted) return;
      SnackbarHelper.showSnackbar(
        context,
        "Gagal mendapatkan lokasi. Waktu tunggu habis.",
        isError: true,
      );
      widget.onLocationValidityChanged?.call(false);
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showSnackbar(
        context,
        "Gagal mendapatkan lokasi.",
        isError: true,
      );
      widget.onLocationValidityChanged?.call(false);
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    if (!widget.isAtLocation) return;

    bool confirm = await _showCameraOrientationSheet(context);
    if (!confirm) return;

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

  void _pickMultipleImages() async {
    if (widget.isAtLocation) return;

    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      final Set<String> newPaths = {};
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
        widget.onFilesSelected(uniqueFiles);
      }
    }
  }

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
                  const Icon(Icons.camera_alt_rounded, size: 50, color: Color(0xFF66BB6A)),
                  const SizedBox(height: 12),
                  const Text(
                    "Gunakan Mode Landscape",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Agar hasil foto lebih optimal, ambillah gambar dalam mode landscape.",
                    style: TextStyle(fontSize: 14),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF66BB6A)),
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
        ) ??
        false;
  }

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
        Row(
          children: [
            if (!widget.isAtLocation)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickMultipleImages,
                  icon: const Icon(Icons.image, color: Color(0xFF4CAF50)),
                  label: const Text("Pilih Gambar", style: TextStyle(color: Color(0xFF4CAF50))),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            if (widget.isAtLocation)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImageFromCamera(context),
                  icon: const Icon(Icons.camera_alt, color: Color(0xFF4CAF50)),
                  label: const Text("Ambil Foto", style: TextStyle(color: Color(0xFF4CAF50))),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (_selectedImages.isNotEmpty) ...[
          const Text("Gambar yang dipilih:", style: TextStyle(fontWeight: FontWeight.bold)),
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
