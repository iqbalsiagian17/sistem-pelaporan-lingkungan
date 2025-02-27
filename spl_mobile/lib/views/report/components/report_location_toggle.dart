import 'package:flutter/material.dart';

class ReportLocationToggle extends StatelessWidget {
  final bool isAtLocation;
  final ValueChanged<bool> onChange;

  const ReportLocationToggle({super.key, required this.isAtLocation, required this.onChange});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => onChange(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAtLocation ? const Color.fromRGBO(76, 175, 80, 1) : Colors.white,
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
                onPressed: () => onChange(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isAtLocation ? const Color.fromRGBO(76, 175, 80, 1) : Colors.white,
                  foregroundColor: !isAtLocation ? const Color(0xFFFFFFFF) : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Tidak di Lokasi"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
