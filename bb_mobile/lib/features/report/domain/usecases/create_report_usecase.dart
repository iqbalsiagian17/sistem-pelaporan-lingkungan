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
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
    required String status, // ✅ Tambahkan parameter status
  }) async {
    return await repository.createReport(
      title: title,
      description: description,
      date: date,
      locationDetails: locationDetails,
      village: village,
      latitude: latitude,
      longitude: longitude,
      isAtLocation: isAtLocation,
      attachments: attachments,
      status: status, // ✅ Kirim ke repository

    );
  }
}
