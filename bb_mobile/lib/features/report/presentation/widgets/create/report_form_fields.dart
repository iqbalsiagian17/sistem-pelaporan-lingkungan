import 'package:flutter/material.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_text_field.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_location_toggle.dart';

class ReportFormFields extends StatelessWidget {
  final bool isAtLocation;
  final Function(bool) onLocationChange;
  final bool isLocationAvailable;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController villageController;
  final TextEditingController locationDetailController;

  const ReportFormFields({
    super.key,
    required this.isAtLocation,
    required this.onLocationChange,
    required this.isLocationAvailable,
    required this.titleController,
    required this.descController,
    required this.villageController,
    required this.locationDetailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportLocationToggle(
          isAtLocation: isAtLocation,
          onChange: onLocationChange,
          isLocationAvailable: isLocationAvailable,
        ),
        const SizedBox(height: 16),
        ReportTextField(title: "Judul", hint: "Masukkan judul laporan", controller: titleController),
        const SizedBox(height: 12),
        ReportTextField(title: "Deskripsi", hint: "Masukkan rincian laporan", controller: descController, maxLines: 5),
        const SizedBox(height: 12),
        if (!isAtLocation)
          ReportTextField(title: "Desa/Kelurahan", hint: "Pilih desa", controller: villageController),
        ReportTextField(title: "Detail Lokasi (Opsional)", hint: "Contoh: Di samping kantor desa", controller: locationDetailController),
      ],
    );
  }
}
