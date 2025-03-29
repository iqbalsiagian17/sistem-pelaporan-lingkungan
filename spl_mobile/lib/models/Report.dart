import 'package:spl_mobile/models/ReportStatusHistory.dart';
import './user.dart';
import './ReportAttachment.dart';
import './ReportEvidences.dart';

class Report {
  final int id;
  final int userId;
  final String reportNumber;
  final String title;
  final String description;
  final String date;
  final String status;
  final int likes;
  final String? village;
  final String? locationDetails;
  final double latitude;
  final double longitude;
  final List<ReportAttachment> attachments;
  final User user;
  final List<ReportStatusHistory> statusHistory;
  final bool isSaved;
  final List<ReportEvidence> evidences;

  Report({
    required this.id,
    required this.userId,
    required this.reportNumber,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.likes,
    this.village,
    this.locationDetails,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    required this.user,
    required this.statusHistory,
    required this.isSaved,
    required this.evidences,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    final reportData = json.containsKey('report') ? json['report'] : json;

    print("📢 Debugging JSON dari API di Flutter: $reportData");

    return Report(
      id: reportData['id'] ?? 0,
      userId: reportData['user_id'] ?? 0,
      reportNumber: reportData['report_number'] ?? 'Unknown',
      title: reportData['title'] ?? 'Tidak ada judul',
      description: reportData['description'] ?? '',
      date: reportData['date'] ?? '0000-00-00',
      status: reportData['status'] ?? 'pending',
      likes: reportData['likes'] ?? 0,
      village: reportData['village'],
      locationDetails: reportData['location_details'],
      latitude: reportData['latitude']?.toDouble() ?? 0.0,
      longitude: reportData['longitude']?.toDouble() ?? 0.0,

      // ✅ Parse attachments
      attachments: (reportData['attachments'] is List)
          ? (reportData['attachments'] as List)
              .map((a) => ReportAttachment.fromJson(a))
              .toList()
          : [],

      // ✅ Parse user
      user: reportData.containsKey('user') && reportData['user'] != null
          ? User.fromJson(reportData['user'])
          : User(id: 0, username: "Unknown", email: "", phoneNumber: "", type: 0),

      // ✅ Parse statusHistory
      statusHistory: (reportData['statusHistory'] is List)
          ? (reportData['statusHistory'] as List)
              .map((s) => s != null
                  ? ReportStatusHistory.fromJson(s)
                  : ReportStatusHistory(
                      id: 0,
                      previousStatus: "unknown",
                      newStatus: "unknown",
                      message: "Tidak ada data",
                      createdAt: "0000-00-00T00:00:00.000Z",
                      admin: User(id: 0, username: "Unknown", email: "", phoneNumber: "", type: 0),
                    ))
              .toList()
          : [],

      // ✅ Parse isSaved
      isSaved: reportData['is_saved'] ?? false,

      // ✅ Parse evidences
      evidences: (reportData['evidences'] is List)
          ? (reportData['evidences'] as List)
              .map((e) => ReportEvidence.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "report_number": reportNumber,
      "title": title,
      "description": description,
      "date": date,
      "status": status,
      "village": village,
      "location_details": locationDetails,
      "latitude": latitude,
      "longitude": longitude,
      "attachments": attachments.map((a) => a.toJson()).toList(),
      "user": user.toJson(),
      "status_history": statusHistory.map((s) => s.toJson()).toList(),
      "is_saved": isSaved,
      "evidences": evidences.map((e) => e.toJson()).toList(),
    };
  }
}
