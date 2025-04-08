import 'package:flutter/material.dart';

class ReportVillagePicker extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSelected;

  const ReportVillagePicker({
    super.key,
    required this.controller,
    required this.onSelected,
  });

  static final List<String> _villages = [
    "Aekbolon Jae", "Aekbolon Julu", "Baru Ara", "Balige I", "Balige II", "Balige III",
    "Bonan Dolok I", "Bonan Dolok II", "Bonan Dolok III", "Hinalang Bagasan",
    "Huta Bulu Mejan", "Huta Dame", "Huta Namora", "Hutagaol Peatalun (Peatalum)",
    "Longat", "Lumban Bul Bul", "Lumban Dolok Haumabange", "Lumban Gaol",
    "Lumban Gorat", "Lumban Pea", "Lumban Pea Timur", "Lumban Silintong", "Tambunan Sunge",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Desa/Kelurahan",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final selected = await showModalBottomSheet<String>(
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
                          itemCount: _villages.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _villages[index];
                            final isSelected = item == controller.text;
                            return ListTile(
                              title: Text(item, style: const TextStyle(fontSize: 14)),
                              tileColor: isSelected ? Color(0xFF66BB6A).withOpacity(0.1) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onTap: () => Navigator.pop(context, item),
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
              controller.text = selected;
              onSelected(selected);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
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
        ),
      ],
    );
  }
}
