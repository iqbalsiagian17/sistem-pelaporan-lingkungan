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
    required this.admin, // ✅ Pastikan admin tidak null
  });

  factory ReportStatusHistory.fromJson(Map<String, dynamic> json) {
    print("📢 Debugging JSON statusHistory di Flutter: $json");

    return ReportStatusHistory(
      id: json['id'] ?? 0,
      previousStatus: json['previous_status'] ?? 'pending',
      newStatus: json['new_status'] ?? 'pending',
      message: json['message'] ?? 'Tidak ada pesan',
      createdAt: json['createdAt'] ?? '0000-00-00T00:00:00.000Z',
      admin: json.containsKey('admin') && json['admin'] != null
          ? User.fromJson(json['admin']) // ✅ Tangani admin jika tersedia
          : User(id: 0, username: "Admin Tidak Diketahui", email: "unknown", phoneNumber: "", type: 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "previous_status": previousStatus,
      "new_status": newStatus,
      "message": message,
      "createdAt": createdAt,
      "admin": admin.toJson(),
    };
  }
}
