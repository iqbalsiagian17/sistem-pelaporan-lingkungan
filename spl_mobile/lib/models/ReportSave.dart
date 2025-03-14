import 'package:spl_mobile/core/constants/api.dart';
import './ReportAttachment.dart';

class ReportSave {
  final int reportId;
  final String title;
  final String description;
  final String location;
  final String date;
  final String status;
  final double latitude;
  final double longitude;
  final List<ReportAttachment> attachments;
  final String imageUrl; // ✅ Tambahkan field imageUrl

  ReportSave({
    required this.reportId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.imageUrl, // ✅ Pastikan imageUrl ada
  });

  factory ReportSave.fromJson(Map<String, dynamic> json) {
    final reportData = json.containsKey('report') ? json['report'] : json;

    // ✅ Pastikan `attachments` berupa list JSON sebelum konversi
    List<ReportAttachment> attachmentList = [];
    if (reportData['attachments'] != null && reportData['attachments'] is List) {
      attachmentList = (reportData['attachments'] as List)
          .map((attachment) => ReportAttachment.fromJson(attachment as Map<String, dynamic>))
          .toList();
    }

    // ✅ Ambil gambar pertama dari attachments, jika tidak ada gunakan default
    String image = attachmentList.isNotEmpty && attachmentList.first.file.isNotEmpty
        ? "${ApiConstants.baseUrl}/${attachmentList.first.file}" // 🔹 URL API untuk gambar pertama
        : "assets/images/default.jpg"; // 🔹 Jika tidak ada gambar, gunakan default

    return ReportSave(
      reportId: reportData['id'] ?? 0,
      title: reportData['title'] ?? "Judul tidak tersedia",
      description: reportData['description'] ?? "Deskripsi tidak tersedia",
      location: reportData['location_details'] ?? "Lokasi tidak diketahui",
      date: reportData['date'] ?? "Tanggal tidak diketahui",
      status: reportData['status'] ?? "Status tidak tersedia",
      latitude: (reportData['latitude'] ?? 0.0).toDouble(),
      longitude: (reportData['longitude'] ?? 0.0).toDouble(),
      attachments: attachmentList, // ✅ Simpan list attachments yang sudah diproses
      imageUrl: image, // ✅ Simpan gambar pertama atau default
    );
  }
}
