import 'package:flutter/material.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_empty_state.dart';

class TermsModalBottomSheet extends StatelessWidget {
  final String content;

  const TermsModalBottomSheet({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    bool isAtBottom = false;

    return StatefulBuilder(
      builder: (context, setState) {
        scrollController.addListener(() {
          final atBottom = scrollController.offset >= scrollController.position.maxScrollExtent;
          if (atBottom != isAtBottom) {
            setState(() => isAtBottom = atBottom);
          }
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 550),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  'Syarat dan Ketentuan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: content.isEmpty
                          ? const TermsDataEmptyState()
                          : TermsDataState(content: content),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAtBottom ? Colors.green[600] : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isAtBottom ? () => Navigator.of(context).pop() : null,
                    child: Text(
                      isAtBottom ? 'Saya Mengerti' : 'Scroll hingga akhir untuk melanjutkan',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
