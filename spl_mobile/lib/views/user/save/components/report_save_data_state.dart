import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/report_save_provider.dart';
import '../../../../models/ReportSave.dart';
import './report_save_empty_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/routes/app_routes.dart';

class ReportSaveDataState extends StatelessWidget {
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportSaveProvider>(
      builder: (context, reportSaveProvider, child) {
        if (reportSaveProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (reportSaveProvider.errorMessage != null) {
          return Center(child: Text("❌ ${reportSaveProvider.errorMessage}"));
        }

        final savedReports = reportSaveProvider.savedReports;

        if (savedReports.isEmpty) {
          return ReportSaveEmptyState(onRetry: onRetry);
        }

        return ListView.builder(
          itemCount: savedReports.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
          itemBuilder: (context, index) {
            final ReportSave report = savedReports[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.green.withOpacity(0.2),
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 12.0 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Gambar Laporan
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: report.imageUrl.isNotEmpty
                            ? report.imageUrl
                            : "assets/images/default.jpg",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(width: 70, height: 70, color: Colors.grey[300]),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/default.jpg", width: 70, height: 70),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 📝 Info Laporan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${report.location}, ${report.date}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),

                          // 🔹 Status dengan warna dari `StatusUtils`
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: StatusUtils.getStatusColor(report.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              StatusUtils.getTranslatedStatus(report.status),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔖 Ikon Bookmark (Dinamis berdasarkan status)
                    IconButton(
                      onPressed: () async {
                        final reportSaveProvider =
                            Provider.of<ReportSaveProvider>(context, listen: false);

                        bool confirmDelete = await _showDeleteConfirmationSheet(context);

                        if (confirmDelete) {
                          await reportSaveProvider.deleteSavedReport(report.reportId);
                        }
                      },
                      icon: Icon(
                        Icons.bookmark, 
                        color: Colors.green, // ✅ Bookmark aktif
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// ✅ **Bottom Sheet Konfirmasi Hapus**
  Future<bool> _showDeleteConfirmationSheet(BuildContext context) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_remove, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text("Hapus Laporan Tersimpan?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text("Laporan ini akan dihapus dari daftar tersimpan. Apakah Anda yakin?",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Batal", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }
}
