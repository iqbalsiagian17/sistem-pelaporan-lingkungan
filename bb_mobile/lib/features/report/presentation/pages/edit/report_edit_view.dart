import 'dart:io';
import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/features/report/data/models/report_attachment_model.dart';
import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/providers/village_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_text_field.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_upload_buttons.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_confirm_modal.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_village_picker.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportEditView extends ConsumerStatefulWidget {
  final ReportModel report;

  const ReportEditView({super.key, required this.report});

  @override
  ConsumerState<ReportEditView> createState() => _ReportEditViewState();
}

class _ReportEditViewState extends ConsumerState<ReportEditView> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationDetailController;
  int? selectedVillageId;
  List<ReportAttachmentModel> existingAttachments = [];
  List<File> newAttachments = [];

  bool isAtLocation = true;
  List<int> deletedAttachmentIds = [];
  bool isSubmitting = false;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    final report = widget.report;

    _titleController = TextEditingController(text: report.title);
    _descController = TextEditingController(text: report.description);
    _locationDetailController = TextEditingController(text: report.locationDetails ?? '');
    selectedVillageId = report.villageId;
    isAtLocation = (report.latitude != 0 && report.longitude != 0);

    existingAttachments = List<ReportAttachmentModel>.from(report.attachments);
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      SnackbarHelper.showSnackbar(context, "Judul dan rincian aduan wajib diisi", isError: true);
      return;
    }

    if (!isAtLocation && selectedVillageId == null) {
      SnackbarHelper.showSnackbar(context, "Pilih lokasi desa/kelurahan", isError: true);
      return;
    }

    final confirm = await showReportConfirmModal(context);
    if (confirm != true) return;

    setState(() => isSubmitting = true);

    try {
      final updatedReport = await ref.read(reportProvider.notifier).updateReport(
        reportId: widget.report.id.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        locationDetails: _locationDetailController.text,
        villageId: !isAtLocation ? selectedVillageId : null,
        isAtLocation: isAtLocation,
        attachments: newAttachments,
        deleteAttachmentIds: deletedAttachmentIds.where((id) => id != 0).toList(),
      );

      if (updatedReport != null) {
        SnackbarHelper.showSnackbar(context, "Laporan berhasil diperbarui!", isError: false);
        context.go(AppRoutes.detailReport, extra: ReportModel.fromEntity(updatedReport));
      } else {
        SnackbarHelper.showSnackbar(context, "Gagal memperbarui aduan.", isError: true);
      }
    } catch (e) {
      SnackbarHelper.showSnackbar(context, "Terjadi kesalahan: $e", isError: true);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final villageListAsync = ref.watch(villageListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportTopBar(title: "Edit Aduan"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ReportTextField(
              title: "Judul",
              hint: "Masukkan judul laporan",
              controller: _titleController,
            ),
            const SizedBox(height: 12),
            ReportTextField(
              title: "Deskripsi",
              hint: "Masukkan rincian laporan",
              controller: _descController,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            if (!isAtLocation)
              ReportVillagePicker(
                selectedVillageId: selectedVillageId,
                onSelected: (val) => setState(() => selectedVillageId = val),
                focusNode: FocusNode(),
                isRequired: true,
              ),
            const SizedBox(height: 12),
            ReportTextField(
              title: "Detail Lokasi (Opsional)",
              hint: "Contoh: Di samping kantor desa",
              controller: _locationDetailController,
            ),
            if (report.latitude != null && report.longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Koordinat Tidak Bisa Diubah: (${report.latitude}, ${report.longitude})",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 12),
            ReportUploadButtons(
              isAtLocation: isAtLocation,
              onFilesSelected: (files) => setState(() => newAttachments = files),
              onLocationCaptured: (_, __) {},
            ),
            if (existingAttachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Lampiran Sebelumnya:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: existingAttachments.map((attachment) {
                  final imageUrl = "${ApiConstants.baseUrl}/${attachment.file}";
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              deletedAttachmentIds.add(attachment.id);
                              existingAttachments.remove(attachment);
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
