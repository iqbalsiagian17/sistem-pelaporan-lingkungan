import 'dart:io';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_form_fields.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_submit_button.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_village_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_location_toggle.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_text_field.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_upload_buttons.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_guide_modal.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_confirm_modal.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:bb_mobile/routes/app_routes.dart';

class ReportCreateView extends ConsumerStatefulWidget {
  const ReportCreateView({super.key});
  @override
  ConsumerState<ReportCreateView> createState() => _ReportCreateViewState();
}

class _ReportCreateViewState extends ConsumerState<ReportCreateView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationDetailController = TextEditingController();
  final _villageController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _villageFocus = FocusNode();
  final FocusNode _locationDetailFocus = FocusNode();

  bool isAtLocation = true;
  bool isSubmitting = false;
  double? latitude;
  double? longitude;
  List<File> attachments = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => showReportGuideTutorial(context));
  }

  Future<void> _handleSubmit() async {

    _titleFocus.unfocus();
    _descFocus.unfocus();
    _villageFocus.unfocus();
    _locationDetailFocus.unfocus();
    FocusScope.of(context).unfocus();
    
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      SnackbarHelper.showSnackbar(context, "Judul dan rincian aduan wajib diisi", isError: true, hasBottomNavbar: true);
      return;
    }
    if (isAtLocation && (latitude == null || longitude == null)) {
      SnackbarHelper.showSnackbar(context, "Koordinat tidak tersedia. Aktifkan GPS Anda", isError: true, hasBottomNavbar: true);
      return;
    }
    if (!isAtLocation && _villageController.text.isEmpty) {
      SnackbarHelper.showSnackbar(context, "Pilih lokasi desa/kelurahan", isError: true, hasBottomNavbar: true);
      return;
    }
    if (attachments.isEmpty) {
      SnackbarHelper.showSnackbar(context, "Unggah minimal 1 gambar", isError: true, hasBottomNavbar: true);
      return;
    }
    if (attachments.length > 5) {
      SnackbarHelper.showSnackbar(context, "Maksimal 5 gambar yang dapat diunggah", isError: true, hasBottomNavbar: true);
      return;
    }

    final confirm = await showReportConfirmModal(context);
    if (confirm != true) return;

    setState(() => isSubmitting = true);

    try {
      final success = await ref.read(reportProvider.notifier).createReport(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        date: DateTime.now().toIso8601String(),
        locationDetails: _locationDetailController.text,
        village: isAtLocation ? null : _villageController.text,
        latitude: isAtLocation ? latitude?.toString() : null,
        longitude: isAtLocation ? longitude?.toString() : null,
        isAtLocation: isAtLocation,
        attachments: attachments,
      );

      if (success) {
        SnackbarHelper.showSnackbar(context, "Aduan berhasil dikirim!", isError: false, hasBottomNavbar: true);
        context.go(AppRoutes.dashboard);
      } else {
        SnackbarHelper.showSnackbar(context, "Gagal mengirim aduan.", isError: true, hasBottomNavbar: true);
      }
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains("belum selesai")) {
        SnackbarHelper.showSnackbar(
          context,
          "Anda masih memiliki laporan yang belum selesai. Selesaikan terlebih dahulu.",
          isError: true,
          hasBottomNavbar: true
        );
      } else if (message.contains("lokasi tidak tersedia")) {
        SnackbarHelper.showSnackbar(
          context,
          "Koordinat tidak tersedia. Aktifkan GPS Anda.",
          isError: true,
          hasBottomNavbar: true
        );
      } else {
        SnackbarHelper.showSnackbar(context, "Terjadi kesalahan: $e", isError: true, hasBottomNavbar: true);
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReportTopBar(title: "Isi Aduan"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportLocationToggle(
              isAtLocation: isAtLocation,
              onChange: (val) => setState(() => isAtLocation = val),
              isLocationAvailable: latitude != null && longitude != null,
            ),
            const SizedBox(height: 16),
            ReportFormFields(
              isAtLocation: isAtLocation,
              onLocationChange: (val) => setState(() => isAtLocation = val),
              isLocationAvailable: latitude != null && longitude != null,
              titleController: _titleController,
              descController: _descController,
              villageController: _villageController,
              locationDetailController: _locationDetailController,
              titleFocus: _titleFocus,
              descFocus: _descFocus,
              villageFocus: _villageFocus,
              locationDetailFocus: _locationDetailFocus,
            ),
            const SizedBox(height: 16),
            ReportUploadButtons(
              isAtLocation: isAtLocation,
              onFilesSelected: (files) => setState(() => attachments = files),
              onLocationCaptured: (lat, long) {
                setState(() {
                  latitude = lat;
                  longitude = long;
                });
              },
            ),
            const SizedBox(height: 16),
            ReportSubmitButton(
              isSubmitting: isSubmitting,
              onPressed: _handleSubmit,
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
