import 'user.dart';

class ReportStatusHistory {
  final int id;
  final String previousStatus;
  final String newStatus;
  final String message;
  final String createdAt;
  final User admin; // ✅ Admin yang mengubah status

  ReportStatusHistory({
    required this.id,
    required this.previousStatus,
    required this.newStatus,
    required this.message,
    required this.createdAt,
    required this.admin, // ✅ Tambahkan admin agar sesuai dengan JSON
  });

  factory ReportStatusHistory.fromJson(Map<String, dynamic> json) {
    print("📢 Debugging JSON statusHistory di Flutter: $json"); // ✅ Debug tiap item statusHistory

    return ReportStatusHistory(
      id: json['id'] ?? 0,
      previousStatus: json['previous_status'] ?? 'pending',
      newStatus: json['new_status'] ?? 'pending',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
      admin: json.containsKey('admin') && json['admin'] != null
          ? User.fromJson(json['admin']) // ✅ Parsing `admin` dengan benar
          : User(id: 0, username: "Unknown", email: "", phoneNumber: "", type: 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "previous_status": previousStatus,
      "new_status": newStatus,
      "message": message,
      "createdAt": createdAt,
      "admin": admin.toJson(), // ✅ Pastikan admin juga dikonversi ke JSON
    };
  }
}
