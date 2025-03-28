import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/user/report/user_report_service.dart';

class ReportSubmitButton extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final String? locationDetails;
  final String? village;
  final String? latitude;
  final String? longitude;
  final bool isAtLocation;
  final List<File> attachments;
  final VoidCallback? onSuccess;

  const ReportSubmitButton({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.locationDetails,
    this.village,
    this.latitude,
    this.longitude,
    required this.isAtLocation,
    required this.attachments,
    this.onSuccess,
  });

  @override
  State<ReportSubmitButton> createState() => _ReportSubmitButtonState();
}

class _ReportSubmitButtonState extends State<ReportSubmitButton> {
  bool isLoading = false;

  Future<void> _confirmBeforeSubmit() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              "Apakah Anda Yakin?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pastikan semua informasi aduan sudah benar. Setelah dikirim, Anda tidak bisa mengubahnya.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Ya, Kirim Sekarang", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      _submitReport();
    }
  }

  Future<void> _submitReport() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        throw Exception("❌ Token tidak ditemukan. Silakan login ulang.");
      }

      final reportService = ReportService();
      bool success = await reportService.createReport(
        title: widget.title.trim(),
        description: widget.description.trim(),
        date: widget.date,
        locationDetails: widget.locationDetails?.trim().isNotEmpty == true
            ? widget.locationDetails!.trim()
            : "Tidak ada detail lokasi",
        village: widget.village?.trim(),
        latitude: widget.latitude ?? "0.0",
        longitude: widget.longitude ?? "0.0",
        isAtLocation: widget.isAtLocation,
        attachments: widget.attachments,
      );

      if (success) {
        widget.onSuccess?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Laporan berhasil dikirim!")),
        );
      } else {
        throw Exception("Gagal mengirim laporan.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim laporan: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _confirmBeforeSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Kirim Aduan", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
