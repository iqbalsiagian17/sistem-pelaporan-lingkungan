import 'package:bb_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:bb_mobile/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatingBottomSheet extends ConsumerStatefulWidget {
  final int reportId;
  final VoidCallback? onSubmitted;

  const RatingBottomSheet({
    super.key,
    required this.reportId,
    this.onSubmitted,
  });

  @override
  ConsumerState<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends ConsumerState<RatingBottomSheet> {
  int? _selectedRating;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _positiveComments = [
    "Penanganannya cepat dan tanggap",
    "Petugas sangat responsif",
    "Terima kasih atas tindak lanjutnya",
  ];

  final List<String> _neutralComments = [
    "Cukup baik, tapi masih bisa ditingkatkan",
    "Layanan sudah oke, namun kurang konsisten",
    "Masih ada yang perlu diperbaiki",
  ];

  final List<String> _negativeComments = [
    "Laporan tidak ditangani dengan baik",
    "Penanganan tidak sesuai harapan",
    "Masalah belum benar-benar selesai",
    "Butuh peninjauan ulang atas laporan ini",
    "Saya merasa laporan saya diabaikan",
  ];


  List<String> get _currentComments {
    if (_selectedRating == null) return [];
    if (_selectedRating! <= 2) return _negativeComments;
    if (_selectedRating == 3) return _neutralComments;
    return _positiveComments;
  }

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_selectedRating == null) return;

    // ⛔️ Konfirmasi jika rating < 2
    if (_selectedRating! < 3) {
      final confirm = await _showLowRatingConfirmation();
      if (!confirm) return; // Batalkan jika user tidak setuju
    }

    setState(() => _isSubmitting = true);

    final success = await ref.read(reportProvider.notifier).submitRating(
          reportId: widget.reportId,
          rating: _selectedRating!,
          review: _reviewController.text,
        );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      widget.onSubmitted?.call();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Penilaian berhasil dikirim!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengirim penilaian.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Beri Penilaian",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Laporan Anda telah selesai ditangani oleh Dinas Lingkungan Hidup Toba. "
              "Silakan berikan penilaian terhadap layanan yang diberikan.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // ⭐ Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  icon: Icon(
                    _selectedRating != null && _selectedRating! >= value
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _selectedRating = value),
                );
              }),
            ),
            const SizedBox(height: 12),

            // 💬 Quick Comment Chips
            if (_reviewController.text.isEmpty && _selectedRating != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _currentComments.map((comment) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _reviewController.text = comment;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          comment,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            if (_reviewController.text.isEmpty && _selectedRating != null)
              const SizedBox(height: 12),

            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tuliskan komentar (opsional)...",
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF66BB6A),
                    width: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: "Kirim Penilaian",
              isLoading: _isSubmitting,
              onPressed: _submitRating,
            ),
          ],
        ),
      ),

    );
  }

  Future<bool> _showLowRatingConfirmation() async {
  return await showModalBottomSheet<bool>(
    context: context,
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
            const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "Penilaian Sangat Rendah",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Penilaian di bawah 3 akan memicu peninjauan ulang laporan oleh Dinas Lingkungan Hidup.\n\n"
              "Untuk memproses peninjauan ulang, Anda *wajib* memberikan komentar yang jelas dan jujur sebagai alasan penilaian rendah.\n"
              "Komentar Anda akan menjadi bahan verifikasi oleh admin, jadi pastikan alasan yang diberikan dapat dipertanggungjawabkan.",
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF66BB6A)),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        color: Color(0xFF66BB6A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Lanjutkan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ) ?? false;
}


}
