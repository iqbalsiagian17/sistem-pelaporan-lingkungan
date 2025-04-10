import 'package:flutter/material.dart';

class ReportSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isAtLocation;
  final bool isLocationValid;

  const ReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
    this.isEnabled = true,
    this.isAtLocation = true,
    this.isLocationValid = true,
  });

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = !isEnabled || isSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: isButtonDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonDisabled ? Colors.grey : const Color(0xFF66BB6A),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Kirim Aduan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
        const SizedBox(height: 8),

        // 🟠 Tampilkan info alasan kenapa tombol dinonaktifkan
        if (isAtLocation && !isLocationValid)
          const Text(
            "Anda berada di luar radius pelaporan (maks. 5 KM dari Balige).",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
