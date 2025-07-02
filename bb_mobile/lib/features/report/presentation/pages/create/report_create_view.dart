import 'dart:io';
import 'package:bb_mobile/features/report/data/models/report_model.dart';
import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_confirm_modal.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_form_fields.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_guide_modal.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_location_toggle.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_submit_button.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_topbar.dart';
import 'package:bb_mobile/features/report/presentation/widgets/create/report_upload_buttons.dart';
import 'package:bb_mobile/routes/app_routes.dart';
import 'package:bb_mobile/widgets/navbar/bottom_navbar.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportCreateView extends ConsumerStatefulWidget {
  const ReportCreateView({super.key});

  @override
  ConsumerState<ReportCreateView> createState() => _ReportCreateViewState();
}

class _ReportCreateViewState extends ConsumerState<ReportCreateView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationDetailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _villageFocus = FocusNode();
  final FocusNode _locationDetailFocus = FocusNode();

  int? selectedVillageId;
  bool isAtLocation = true;
  bool isSubmitting = false;
  bool isLocationValid = true;
  bool isLoadingLocation = true;
  double? latitude;
  double? longitude;
  List<File> attachments = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      showReportGuideTutorial(context);
    });
  }

  Future<void> _handleSubmit() async {
    _titleFocus.unfocus();
    _descFocus.unfocus();
    _villageFocus.unfocus();
    _locationDetailFocus.unfocus();
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (isAtLocation) {
      if (latitude == null || longitude == null) {
        SnackbarHelper.showSnackbar(context, "Lokasi belum ditemukan. Mohon aktifkan GPS Anda.", isError: true);
        return;
      }
    } else {
      if (selectedVillageId == null) {
        SnackbarHelper.showSnackbar(context, "Pilih lokasi desa/kelurahan", isError: true);
        return;
      }
    }

    if (attachments.isEmpty) {
      SnackbarHelper.showSnackbar(context, "Unggah minimal 1 gambar", isError: true);
      return;
    }

    if (attachments.length > 5) {
      SnackbarHelper.showSnackbar(context, "Maksimal 5 gambar yang dapat diunggah", isError: true);
      return;
    }

    final confirm = await showReportConfirmModal(context);
    if (confirm != true) return;

    setState(() => isSubmitting = true);

    try {
      final report = await ref.read(reportProvider.notifier).createReport(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        date: DateTime.now().toIso8601String(),
        locationDetails: _locationDetailController.text,
        villageId: isAtLocation ? null : selectedVillageId,
        latitude: isAtLocation ? latitude?.toString() : null,
        longitude: isAtLocation ? longitude?.toString() : null,
        isAtLocation: isAtLocation,
        attachments: attachments,
      );

      if (report != null) {
        if (report.status == 'draft') {
          SnackbarHelper.showSnackbar(context, "Laporan Anda disimpan sebagai draft dan akan dikirim otomatis setelah laporan aktif selesai.", isError: false);
        } else {
          SnackbarHelper.showSnackbar(context, "Aduan berhasil dikirim!", isError: false);
        }
        context.go(AppRoutes.detailReport, extra: ReportModel.fromEntity(report));
      } else {
        SnackbarHelper.showSnackbar(context, "Gagal mengirim aduan.", isError: true);
      }
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains("belum selesai")) {
        SnackbarHelper.showSnackbar(context, "Laporan Anda disimpan sebagai draft karena masih ada laporan aktif.", isError: false);
      } else if (message.contains("lokasi tidak tersedia") || message.contains("invalid location")) {
        SnackbarHelper.showSnackbar(context, "Gagal mengirim karena lokasi tidak valid atau tidak terdeteksi.", isError: true);
      } else {
        SnackbarHelper.showSnackbar(context, "Terjadi kesalahan: $e", isError: true);
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  onForceChangeToNotAtLocation: () => setState(() => isAtLocation = false),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: ReportFormFields(
                    isAtLocation: isAtLocation,
                    onLocationChange: (val) => setState(() => isAtLocation = val),
                    isLocationAvailable: latitude != null && longitude != null,
                    titleController: _titleController,
                    descController: _descController,
                    locationDetailController: _locationDetailController,
                    titleFocus: _titleFocus,
                    descFocus: _descFocus,
                    villageFocus: _villageFocus,
                    locationDetailFocus: _locationDetailFocus,
                    selectedVillageId: selectedVillageId,
                    onVillageChanged: (val) => setState(() => selectedVillageId = val),
                  ),
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
                  onLocationValidityChanged: (isValid) {
                    setState(() {
                      isLocationValid = isValid;
                      isLoadingLocation = false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ReportSubmitButton(
                  isSubmitting: isSubmitting,
                  onPressed: _handleSubmit,
                  isEnabled: !isAtLocation || isLocationValid,
                  isAtLocation: isAtLocation,
                  isLocationValid: isLocationValid,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavbar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        ),
        if (isAtLocation && isLoadingLocation)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF66BB6A),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Melacak lokasi...",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
