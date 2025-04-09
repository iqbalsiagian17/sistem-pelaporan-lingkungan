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

  // 🔹 Warna status yang lebih modern dan simpel
  static Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFBC02D); // Kuning elegan
      case 'rejected':
        return const Color(0xFFE53935); // Merah elegan
      case 'verified':
        return const Color(0xFF1E88E5); // Biru bersih
      case 'in_progress':
        return const Color(0xFF8E24AA); // Ungu segar
      case 'completed':
        return const Color(0xFF43A047); // Hijau stabil
      case 'closed':
        return const Color(0xFF757575); // Abu netral
      default:
        return const Color(0xFFBDBDBD); // Abu terang untuk status tidak dikenal
    }
  }

  // 🔹 Ganti status dalam string jadi versi Indonesia
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
