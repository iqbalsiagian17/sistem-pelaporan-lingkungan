import 'package:flutter/material.dart';

class StatusUtils {
  // 🔹 Konversi status dari backend ke bahasa Indonesia
  static String getTranslatedStatus(String? status) {
    switch (status) {
      case 'pending':
        return "Menunggu Konfirmasi";
      case 'rejected':
        return "Ditolak";
      case 'verified':
        return "Diverifikasi";
      case 'in_progress':
        return "Sedang Diproses";
      case 'completed':
        return "Selesai";
      case 'closed':
        return "Ditutup";
      default:
        return "Status Tidak Diketahui";
    }
  }

  // 🔹 Tentukan warna status untuk UI
  static Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade300; // 🔸 Menunggu Konfirmasi
      case 'rejected':
        return Colors.red.shade400; // 🔴 Ditolak
      case 'verified':
        return Colors.blue.shade400; // 🔵 Diverifikasi
      case 'in_progress':
        return Colors.purple.shade400; // 🟣 Sedang Diproses
      case 'completed':
        return Color(0xFF66BB6A); // 🟢 Selesai
      case 'closed':
        return Colors.grey.shade500; // ⚫ Ditutup
      default:
        return Colors.grey.shade300; // ❓ Status tidak dikenal
    }
  }

static String replaceStatusKeywords(String message) {
  const statusKeys = [
    'pending',
    'rejected',
    'verified',
    'in_progress',
    'completed',
    'closed',
  ];

  for (final key in statusKeys) {
    message = message.replaceAll('"$key"', '"${getTranslatedStatus(key)}"');
  }
  return message;
}



}
