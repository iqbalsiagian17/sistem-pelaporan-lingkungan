import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // ✅ Warna lebih soft
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("0", "Aduan dikirim"),
          _divider(),
          _buildStatItem("0", "Aduan selesai"),
          _divider(),
          _buildStatItem("0", "Aduan disimpan"),
        ],
      ),
    );
  }

  /// ✅ Fungsi Widget Statistik (Lebih Simpel)
  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// ✅ Divider Vertikal (Garis Pembatas Antar Statistik)
  Widget _divider() {
    return Container(
      height: 30,
      width: 1.5,
      color: Colors.black12, // ✅ Garis pembatas antar statistik
    );
  }
}
