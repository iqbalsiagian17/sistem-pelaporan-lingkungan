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
  final TextEditingController locationDetailController;

  final FocusNode titleFocus;
  final FocusNode descFocus;
  final FocusNode villageFocus;
  final FocusNode locationDetailFocus;

  final int? selectedVillageId;
  final void Function(int)? onVillageChanged;

  const ReportFormFields({
    super.key,
    required this.isAtLocation,
    required this.onLocationChange,
    required this.isLocationAvailable,
    required this.titleController,
    required this.descController,
    required this.locationDetailController,
    required this.titleFocus,
    required this.descFocus,
    required this.villageFocus,
    required this.locationDetailFocus,
    required this.selectedVillageId,
    required this.onVillageChanged,
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
          isRequired: true,
        ),
        const SizedBox(height: 12),

        ReportTextField(
          title: "Deskripsi",
          hint: "Masukkan rincian laporan",
          controller: descController,
          maxLines: 5,
          focusNode: descFocus,
          validator: (val) => Validators.validateNotEmpty(val, fieldName: "Deskripsi"),
          isRequired: true,
        ),
        const SizedBox(height: 12),

        if (!isAtLocation)
          ReportVillagePicker(
            selectedVillageId: selectedVillageId,
            onSelected: onVillageChanged!,
            focusNode: villageFocus,
            isRequired: true,
          ),

        const SizedBox(height: 12),

        ReportTextField(
          title: "Detail Lokasi (Opsional)",
          hint: "Contoh: Di samping kantor desa",
          controller: locationDetailController,
          focusNode: locationDetailFocus,
        ),
      ],
    );
  }
}
