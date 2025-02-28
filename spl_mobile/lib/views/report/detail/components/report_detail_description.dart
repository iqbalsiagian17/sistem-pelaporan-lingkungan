import 'package:flutter/material.dart';

class ReportDetailDescription extends StatelessWidget {
  final String? description;

  const ReportDetailDescription({super.key, this.description});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth, // ✅ Pastikan tidak melebihi layar
          ),
          child: Text(
            description ?? "Deskripsi tidak tersedia",
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context), // ✅ Font size responsif
              color: Colors.black87,
              height: 1.5, // ✅ Spasi antar baris agar lebih nyaman dibaca
            ),
            textAlign: TextAlign.justify, // ✅ Rata kiri-kanan agar lebih rapi
          ),
        );
      },
    );
  }

  // ✅ Fungsi untuk menentukan ukuran font secara responsif
  double _getResponsiveFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 360) {
      return 12; // Untuk layar kecil (misalnya HP lama)
    } else if (screenWidth < 600) {
      return 14; // Untuk layar sedang (HP modern)
    } else {
      return 16; // Untuk layar lebih besar (tablet)
    }
  }
}
