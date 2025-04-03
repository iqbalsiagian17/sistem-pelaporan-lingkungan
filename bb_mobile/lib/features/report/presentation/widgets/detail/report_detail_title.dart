import 'package:bb_mobile/widgets/chip/custom_chip.dart';
import 'package:flutter/material.dart';

class ReportDetailTitle extends StatelessWidget {
  final String? title;

  const ReportDetailTitle({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      label: title ?? "Judul tidak tersedia", // ✅ Gunakan CustomChip untuk tampilan lebih menarik
    );
  }
}
