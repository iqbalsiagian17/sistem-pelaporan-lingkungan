import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spl_mobile/routes/app_routes.dart';
import './report_list_empety.dart'; // ✅ Import empty state

class ReportSaveDataState extends StatefulWidget {
  final List<Map<String, dynamic>> savedReports; // ✅ Fix: Changed to dynamic
  final VoidCallback onRetry;

  const ReportSaveDataState({super.key, required this.savedReports, required this.onRetry});

  @override
  State<ReportSaveDataState> createState() => _ReportSaveDataState();
}

class _ReportSaveDataState extends State<ReportSaveDataState> {
  String selectedStatus = "Semua"; // ✅ Default filter
  int currentPage = 1; // ✅ Default page number
  final int itemsPerPage = 10; // ✅ Pagination limit

  List<Map<String, dynamic>> get filteredReports {
    List<Map<String, dynamic>> reports = widget.savedReports;
    if (selectedStatus != "Semua") {
      reports = reports.where((report) => report["status"] == selectedStatus).toList();
    }
    return reports.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();
  }

  void _nextPage() {
    if (currentPage * itemsPerPage < widget.savedReports.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.savedReports.isEmpty
        ? ReportListAllEmptyState(onRetry: widget.onRetry) // ✅ Show empty state if no reports
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter Status:",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          items: ["Semua", "Dalam Proses", "Disposisi", "Selesai", "Ditolak"]
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedStatus = value;
                                currentPage = 1; // ✅ Reset pagination on filter change
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 📄 Report List with Pagination
              Expanded(
                child: ListView.builder(
                  itemCount: filteredReports.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                  itemBuilder: (context, index) {
                    final report = filteredReports[index];

                    return GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.reportDetail, extra: {"report": report});
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 12.0 : 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼️ Report Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                report["image"] ?? "assets/images/default.jpg",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 📝 Report Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report["title"] ?? "Judul tidak tersedia",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${report["location"] ?? "Lokasi tidak tersedia"}, ${report["time"] ?? "Waktu tidak diketahui"}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE9DFFF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      report["status"] ?? "Status tidak diketahui",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9C27B0),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔖 Active Bookmark Icon
                            IconButton(
                              onPressed: () {
                                // TODO: Add remove from saved reports functionality
                              },
                              icon: const Icon(Icons.bookmark_border, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ⏩ Pagination Controls
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1 ? _previousPage : null,
                      icon: const Icon(Icons.chevron_left, color: Colors.green),
                      splashRadius: 20, // ✅ Smaller touch area
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$currentPage",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage * itemsPerPage < widget.savedReports.length ? _nextPage : null,
                      icon: const Icon(Icons.chevron_right, color: Colors.green),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

