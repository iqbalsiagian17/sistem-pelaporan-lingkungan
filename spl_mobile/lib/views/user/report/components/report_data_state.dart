import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Report.dart';
import 'package:spl_mobile/providers/user_report_provider.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import 'package:spl_mobile/core/constants/api.dart';
import 'package:spl_mobile/core/utils/status_utils.dart';
import 'package:spl_mobile/widgets/show_snackbar.dart';
import 'report_empty_state.dart';

class ReportDataState extends StatelessWidget {
  final List<Report> reports;
  final VoidCallback onRetry;

  const ReportDataState({super.key, required this.reports, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? ReportEmptyState(onRetry: onRetry)
        : ListView.builder(
            itemCount: reports.length,
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            itemBuilder: (context, index) {
              final report = reports[index];

              // ✅ Ambil URL gambar pertama dari attachments jika ada
              String imageUrl = (report.attachments.isNotEmpty)
                  ? "${ApiConstants.baseUrl}/${report.attachments.first.file}"
                  : "";

              return InkWell(
                onTap: () {
                  context.push(AppRoutes.reportDetail, extra: report);
                },
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.green.withOpacity(0.2),
                child: Padding(
                  key: ValueKey(report.id),
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼 Gambar laporan menggunakan `CachedNetworkImage`
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _loadingPlaceholder(),
                            errorWidget: (context, url, error) => _defaultImage(),
                          ),
                        ),
                      if (imageUrl.isNotEmpty) const SizedBox(width: 12),

                      // 📝 Info Aduan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title.isNotEmpty ? report.title : "Judul tidak tersedia",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${report.village?.isNotEmpty == true ? report.village : report.locationDetails ?? "Lokasi tidak tersedia"}, ${report.date.isNotEmpty ? report.date : "Tanggal tidak diketahui"}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),

                            // 🔹 Status Laporan dengan Animasi Warna
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
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

                      if (report.status == "pending")
                        IconButton(
                          onPressed: () => _confirmDelete(context, report),
                          icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  // 🔹 Placeholder saat gambar loading
  Widget _loadingPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    );
  }

  // 🔹 Gambar default jika gagal dimuat
  Widget _defaultImage() {
    return Image.asset(
      "assets/images/report/report1.jpg",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
  void _confirmDelete(BuildContext context, Report report) async {
    HapticFeedback.mediumImpact(); // ✅ Efek getaran saat membuka modal
    bool? confirmDelete = await showModalBottomSheet<bool>(
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
              const Icon(Icons.delete_outline, size: 50, color: Colors.red), // 🔥 Ikon Delete Besar
              const SizedBox(height: 12),
              const Text(
                "Hapus Laporan?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Laporan yang dihapus tidak dapat dikembalikan. Apakah Anda yakin ingin melanjutkan?",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
    );

    if (confirmDelete == true) {
      // ✅ Hapus laporan jika user mengonfirmasi
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      bool success = await reportProvider.deleteReport(report.id.toString());

      if (success) {
        SnackbarHelper.showSnackbar(context, "Laporan berhasil dihapus"); // ✅ Notifikasi sukses
      } else {
        SnackbarHelper.showSnackbar(context, "Gagal menghapus laporan", isError: true); // ❌ Notifikasi gagal
      }
    }
  }
}
