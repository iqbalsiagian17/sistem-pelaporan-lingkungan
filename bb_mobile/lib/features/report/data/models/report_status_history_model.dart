import 'package:bb_mobile/features/report/domain/entities/report_status_history_entity.dart';
import 'package:bb_mobile/features/report/data/models/user_model.dart';

class ReportStatusHistoryModel extends ReportStatusHistoryEntity {
  ReportStatusHistoryModel({
    required int id,
    required String previousStatus,
    required String newStatus,
    required String message,
    required String createdAt,
    required UserModel admin,
  }) : super(
          id: id,
          previousStatus: previousStatus,
          newStatus: newStatus,
          message: message,
          createdAt: createdAt,
          admin: admin,
        );

  factory ReportStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReportStatusHistoryModel(
      id: json['id'] ?? 0,
      previousStatus: json['previous_status'] ?? '',
      newStatus: json['new_status'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
      admin: UserModel.fromJson(json['admin'] ?? {}),
    );
  }

  factory ReportStatusHistoryModel.fromEntity(ReportStatusHistoryEntity entity) {
  return ReportStatusHistoryModel(
    id: entity.id,
    previousStatus: entity.previousStatus,
    newStatus: entity.newStatus,
    message: entity.message,
    createdAt: entity.createdAt,
    admin: UserModel.fromEntity(entity.admin), // konversi admin juga
  );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'previous_status': previousStatus,
        'new_status': newStatus,
        'message': message,
        'createdAt': createdAt,
        'admin': (admin as UserModel).toJson(), // ✅ typecast biar bisa .toJson()
      };

      
}
