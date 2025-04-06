import 'package:bb_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showReportGuideTutorial(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenGuide = prefs.getBool('hasSeenReportGuideTutorial') ?? false;

  if (!hasSeenGuide) {
    await Future.delayed(const Duration(milliseconds: 500));

    if (context.mounted) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.help_outline_rounded, size: 48, color: Colors.green),
                const SizedBox(height: 16),
                const Text("Wajib Membaca!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  "Sebelum mengirim aduan, silakan baca terlebih dahulu tata cara pelaporan agar aduan kamu valid dan dapat ditindaklanjuti dengan cepat.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                        context.go(AppRoutes.reportGuides);
                     },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Lihat Tata Cara"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await prefs.setBool('hasSeenReportGuideTutorial', true);
    }
  }
}
