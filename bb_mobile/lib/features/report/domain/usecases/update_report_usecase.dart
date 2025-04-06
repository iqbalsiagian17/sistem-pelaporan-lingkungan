import 'dart:io';
import 'package:bb_mobile/features/report/domain/repositories/report_repository.dart';

class UpdateReportUseCase {
  final ReportRepository repository;

  UpdateReportUseCase(this.repository);

  Future<bool> execute({
    required String reportId,
    String? title,
    String? description,
    String? locationDetails,
    String? village,
    String? latitude,
    String? longitude,
    bool? isAtLocation,
    List<File>? attachments,
    List<int>? deleteAttachmentIds,
  }) {
    return repository.updateReport(
      reportId: reportId,
      title: title,
      description: description,
      locationDetails: locationDetails,
      village: village,
      latitude: latitude,
      longitude: longitude,
      isAtLocation: isAtLocation,
      attachments: attachments,
      deleteAttachmentIds: deleteAttachmentIds,
    );
  }
}
