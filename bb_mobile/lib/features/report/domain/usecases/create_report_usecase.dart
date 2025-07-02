import 'dart:io';
import 'package:bb_mobile/features/report/domain/entities/report_entity.dart';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class CreateReportUseCase {
  final ReportRepository repository;

  CreateReportUseCase(this.repository);

  Future<ReportEntity?> execute({
    required String title,
    required String description,
    required String date,
    String? locationDetails,
    int? villageId, // ✅ Ganti dari String? village
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
    required String status,
  }) async {
    return await repository.createReport(
      title: title,
      description: description,
      date: date,
      locationDetails: locationDetails,
      villageId: villageId, // ✅ Sesuaikan ke parameter repository
      latitude: latitude,
      longitude: longitude,
      isAtLocation: isAtLocation,
      attachments: attachments,
      status: status,
    );
  }
}
