import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/report/presentation/providers/village_provider.dart';
import 'package:bb_mobile/core/utils/validators.dart';
import 'package:collection/collection.dart'; 

class ReportVillagePicker extends ConsumerWidget {
  final int? selectedVillageId;
  final void Function(int id) onSelected;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final bool isRequired;

  const ReportVillagePicker({
    super.key,
    required this.selectedVillageId,
    required this.onSelected,
    required this.focusNode,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final villagesAsync = ref.watch(villageListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Pilih Desa/Kelurahan",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: isRequired
                ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        villagesAsync.when(
          data: (villages) {
            final selectedVillage = villages.firstWhereOrNull((v) => v.id == selectedVillageId);

            final controller = TextEditingController(text: selectedVillage?.name ?? "");

            return GestureDetector(
              onTap: () async {
                final selected = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Pilih Desa/Kelurahan",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.separated(
                              itemCount: villages.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final village = villages[index];
                                return ListTile(
                                  title: Text(village.name, style: const TextStyle(fontSize: 14)),
                                  tileColor: village.id == selectedVillageId
                                      ? const Color(0xFF66BB6A).withOpacity(0.1)
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onTap: () => Navigator.pop(context, {
                                    'id': village.id,
                                    'name': village.name,
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );

                if (selected != null) {
                  onSelected(selected['id']);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  validator: (val) {
                    if (isRequired && selectedVillageId == null) {
                      return "Pilih desa / kelurahan";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    hintText: "Pilih Desa/Kelurahan",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (err, stack) => Text("Gagal memuat desa: $err"),
        ),
      ],
    );
  }
}
