import 'package:flutter/material.dart';
import 'package:bb_mobile/core/utils/validators.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_text_field.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_village_picker.dart';

class ReportFormFields extends StatelessWidget {
  final bool isAtLocation;
  final Function(bool) onLocationChange;
  final bool isLocationAvailable;

  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController villageController;
  final TextEditingController locationDetailController;

  final FocusNode titleFocus;
  final FocusNode descFocus;
  final FocusNode villageFocus;
  final FocusNode locationDetailFocus;

  const ReportFormFields({
    super.key,
    required this.isAtLocation,
    required this.onLocationChange,
    required this.isLocationAvailable,
    required this.titleController,
    required this.descController,
    required this.villageController,
    required this.locationDetailController,
    required this.titleFocus,
    required this.descFocus,
    required this.villageFocus,
    required this.locationDetailFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportTextField(
          title: "Judul",
          hint: "Masukkan judul laporan",
          controller: titleController,
          focusNode: titleFocus,
          validator: (val) => Validators.validateNotEmpty(val, fieldName: "Judul"),
        ),
        const SizedBox(height: 12),

        ReportTextField(
          title: "Deskripsi",
          hint: "Masukkan rincian laporan",
          controller: descController,
          maxLines: 5,
          focusNode: descFocus,
          validator: (val) => Validators.validateNotEmpty(val, fieldName: "Deskripsi"),
        ),
        const SizedBox(height: 12),

        if (!isAtLocation)
          ReportVillagePicker(
            controller: villageController,
            focusNode: villageFocus,
            onSelected: (val) {},
            validator: (val) => Validators.validateNotEmpty(val, fieldName: "Nama Desa"),
          ),

        const SizedBox(height: 12),

        ReportTextField(
          title: "Detail Lokasi (Opsional)",
          hint: "Contoh: Di samping kantor desa",
          controller: locationDetailController,
          focusNode: locationDetailFocus,
          // Tidak pakai validator, karena ini opsional
        ),
      ],
    );
  }
}
