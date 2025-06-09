import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedType;
  final Function(String) onFilterChanged;

  const NotificationTopBar({
    super.key,
    required this.selectedType,
    required this.onFilterChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF66BB6A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/dashboard'),
      ),
      title: const Text(
        'Kotak Masuk',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterBottomSheet(context),
        ),
      ],
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Filter Notifikasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._buildFilterOptions(context),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFilterOptions(BuildContext context) {
    final filters = {
      "all": "Semua Notifikasi",
      "report": "Laporan",
      "report_saved_update": "Laporan Tersimpan",
      "forum": "Forum",
      "campaign": "Kampanye",
      "general": "Umum",
    };

    return filters.entries.map((entry) {
      final isSelected = entry.key == selectedType;
      return ListTile(
        title: Text(entry.value),
        trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF66BB6A)) : null,
        onTap: () {
          Navigator.pop(context);
          onFilterChanged(entry.key);
        },
      );
    }).toList();
  }
}
