import 'package:intl/intl.dart';

class DateUtilsCustom {
  /// Format tanggal menjadi 'dd MMMM yyyy' (contoh: 25 Februari 2025)
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  /// Format waktu menjadi 'HH:mm' (contoh: 14:30)
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format tanggal dengan waktu (contoh: 25 Feb 2025, 14:30)
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  /// Hitung selisih waktu seperti '2 jam yang lalu' atau '5 hari yang lalu'
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit yang lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam yang lalu';
    if (difference.inDays < 7) return '${difference.inDays} hari yang lalu';

    return formatDate(date); // Kembali ke format tanggal jika lebih dari 7 hari
  }
}
