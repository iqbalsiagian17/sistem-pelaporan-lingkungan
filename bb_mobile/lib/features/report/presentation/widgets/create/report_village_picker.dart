import 'package:flutter/material.dart';

class ReportVillagePicker extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSelected;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final bool isRequired; // ✅ Tambahan

  const ReportVillagePicker({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.focusNode,
    this.validator,
    this.isRequired = false, // ✅ Default false
  });

  static final List<String> _villages = [
    "Desa Hutanamora",
    "Desa Hutagaol Peatalun",
    "Desa Hinalang Bagasan",
    "Desa Matio",
    "Desa Lumban Pea",
    "Desa Hutabulu Mejan",
    "Desa Lumban Gaol",
    "Desa Parsuratan",
    "Desa Baruara",
    "Desa Aek Bolon Julu",
    "Desa Sibolahotang SAS",
    "Desa Lumban Bulbul",
    "Desa Sianipar Sihailhail",
    "Desa Silalahi Pagar Batu",
    "Desa Lumban Silintong",
    "Desa Saribu Raja Janji Maria",
    "Desa Longat",
    "Desa Balige II",
    "Desa Aek Bolon Jae",
    "Desa Lumban Gorat",
    "Desa Sibuntuon",
    "Desa Siboruon",
    "Desa Paindoan",
    "Desa Bonan Dolok I",
    "Desa Bonan Dolok II",
    "Desa Bonan Dolok III",
    "Desa Huta Dame",
    "Kelurahan Balige I",
    "Kelurahan Balige III",
    "Kelurahan Pardede Onan",
    "Kelurahan Sangkar Nihuta",
    "Kelurahan Lumban Dolok Hauma Bange",
    "Kelurahan Napitupulu Bagasan",
    "Desa Lumban Pea Timur",
    "Desa Tambunan Sunge",
  ];

  @override
  Widget build(BuildContext context) {
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
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  ]
                : [],
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
                              tileColor: isSelected ? const Color(0xFF66BB6A).withOpacity(0.1) : null,
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
              focusNode: focusNode,
              validator: validator,
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
