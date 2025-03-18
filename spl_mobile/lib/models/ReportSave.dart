import 'package:spl_mobile/core/constants/api.dart';
import './ReportAttachment.dart';
import './Report.dart';
import './user.dart';
import './ReportStatusHistory.dart';

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
  final String imageUrl;
  final int userId;
  final String reportNumber;
  final User user;
  final List<ReportStatusHistory> statusHistory;
  final bool isSaved; // ✅ Tambahkan properti isSaved


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
    required this.imageUrl,
    required this.userId,
    required this.reportNumber,
    required this.user,
    required this.statusHistory,
    required this.isSaved, // ✅ Tambahkan di konstruktor
  });

  factory ReportSave.fromJson(Map<String, dynamic> json) {
  final reportData = json.containsKey('report') ? json['report'] : json;

  List<ReportAttachment> attachmentList = [];
  if (reportData['attachments'] != null && reportData['attachments'] is List) {
    attachmentList = (reportData['attachments'] as List)
        .map((attachment) => ReportAttachment.fromJson(attachment as Map<String, dynamic>))
        .toList();
  }

  String image = attachmentList.isNotEmpty && attachmentList.first.file.isNotEmpty
      ? "${ApiConstants.baseUrl}/${attachmentList.first.file}"
      : "assets/images/default.jpg";

  // ✅ Pastikan statusHistory tidak null
  List<ReportStatusHistory> statusHistoryList = [];
  if (reportData.containsKey('statusHistory') && reportData['statusHistory'] is List) {
    statusHistoryList = (reportData['statusHistory'] as List)
        .map((history) => ReportStatusHistory.fromJson(history))
        .toList();
  }

  print("📌 Debugging: Parsing statusHistory di ReportSave.fromJson");
  print("🔍 StatusHistory yang diparse: $statusHistoryList");

  return ReportSave(
    reportId: reportData['id'] ?? 0,
    title: reportData['title'] ?? "Judul tidak tersedia",
    description: reportData['description'] ?? "Deskripsi tidak tersedia",
    location: reportData['location_details'] ?? "Lokasi tidak diketahui",
    date: reportData['date'] ?? "Tanggal tidak diketahui",
    status: reportData['status'] ?? "Status tidak tersedia",
    latitude: (reportData['latitude'] ?? 0.0).toDouble(),
    longitude: (reportData['longitude'] ?? 0.0).toDouble(),
    attachments: attachmentList,
    imageUrl: image,
    userId: reportData['user_id'] ?? 0,
    reportNumber: reportData['report_number'] ?? "Unknown",
    user: reportData.containsKey('user') && reportData['user'] != null
        ? User.fromJson(reportData['user'])
        : User(id: 0, username: "Unknown", email: "", phoneNumber: "", type: 0),
    statusHistory: statusHistoryList, // ✅ Pastikan ini tidak kosong!
    isSaved: reportData['is_saved'] ?? false, // ✅ Ambil dari JSON, default ke false jika null

  );
  
}



/// ✅ **Konversi ReportSave ke Report**
Report toReport() {
  print("📌 Debugging: Konversi ReportSave ke Report");
  print("🔍 ReportSave ID: $reportId, Status: $status");
  print("🔍 StatusHistory sebelum konversi: $statusHistory");

  return Report(
    id: reportId,
    userId: userId,
    reportNumber: reportNumber,
    title: title,
    description: description,
    date: date,
    status: status,
    likes: 0, // Bisa diubah jika ada data like
    village: location,
    locationDetails: location,
    latitude: latitude,
    longitude: longitude,
    attachments: attachments,
    user: user,
    statusHistory: statusHistory, // ✅ Pastikan ini tidak kosong!
      isSaved: isSaved, // ✅ Pastikan isSaved dikonversi ke Report


  );
}

}
