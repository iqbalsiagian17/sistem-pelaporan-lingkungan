import 'package:flutter/material.dart';

class ReportSaveEmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const ReportSaveEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/report/empty_report.png', // Pastikan gambar tersedia
            height: 200,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada aduan',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ).copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4CAF50), // 💚 Hijau terang
                    Color(0xFF81C784), // 💚 Hijau muda
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'Ulangi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Warna teks kontras
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
