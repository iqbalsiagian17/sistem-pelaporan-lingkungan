import 'package:flutter/material.dart';

class ReportLocationToggle extends StatelessWidget {
  final bool isAtLocation;
  final bool isLocationAvailable;
  final ValueChanged<bool> onChange;
  final bool isDisabled;

  const ReportLocationToggle({
    super.key,
    required this.isAtLocation,
    required this.isLocationAvailable,
    required this.onChange,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final infoColor = isLocationAvailable ? const Color(0xFF2E7D32) : const Color(0xFFF57F17);
    final bgColor = isLocationAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1);
    final borderColor = isLocationAvailable ? const Color(0xFF66BB6A) : const Color(0xFFFFEE58);
    final icon = isLocationAvailable ? Icons.check_circle : Icons.warning_amber_rounded;
    final message = isLocationAvailable
        ? "Lokasi Anda telah berhasil terdeteksi secara otomatis melalui GPS."
        : "Kami belum bisa mendeteksi lokasi Anda. Pastikan GPS aktif dan izin lokasi telah diberikan.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apakah Anda masih di lokasi kejadian?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isDisabled ? null : () => onChange(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAtLocation ? const Color(0xFF4CAF50) : Colors.white,
                  foregroundColor: isAtLocation ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Masih di Lokasi"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: isDisabled ? null : () => onChange(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isAtLocation ? const Color(0xFF4CAF50) : Colors.white,
                  foregroundColor: !isAtLocation ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Tidak di Lokasi"),
              ),
            ),
          ],
        ),
        if (isAtLocation) ...[
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: infoColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 14, color: infoColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
