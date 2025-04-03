import 'package:flutter/material.dart';

class ReportSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;

  const ReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Kirim Aduan", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
