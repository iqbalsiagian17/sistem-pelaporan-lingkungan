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
  final VoidCallback? onSuccess; // ✅ Tambahkan callback jika berhasil

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

  Future<void> _submitReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        throw Exception("❌ Token tidak ditemukan. Silakan login ulang.");
      }

      final reportService = ReportService();
      bool success = await reportService.createReport(
        title: widget.title,
        description: widget.description,
        date: widget.date,
        locationDetails: widget.locationDetails,
        village: widget.village,
        latitude: widget.latitude,
        longitude: widget.longitude,
        isAtLocation: widget.isAtLocation,
        attachments: widget.attachments,
      );

      if (success) {
        widget.onSuccess?.call(); // ✅ Callback jika sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Laporan berhasil dikirim!")),
        );
      } else {
        throw Exception("❌ Gagal mengirim laporan.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal mengirim laporan: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitReport,
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
