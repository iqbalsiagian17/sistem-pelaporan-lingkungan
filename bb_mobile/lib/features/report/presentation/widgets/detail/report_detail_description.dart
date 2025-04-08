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
            maxWidth: constraints.maxWidth, 
          ),
          child: Text(
            description ?? "Deskripsi tidak tersedia",
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context), 
              color: Colors.black87,
              height: 1.5, 
            ),
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }

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
