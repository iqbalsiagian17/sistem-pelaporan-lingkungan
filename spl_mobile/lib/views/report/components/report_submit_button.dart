import 'package:flutter/material.dart';

class ReportSubmitButton extends StatelessWidget {
  const ReportSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Tambahkan logika submit laporan
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          "Kirim Aduan",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
