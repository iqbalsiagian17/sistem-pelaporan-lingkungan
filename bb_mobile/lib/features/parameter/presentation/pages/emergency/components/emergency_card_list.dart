import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EmergencyCardList extends StatelessWidget {
  final String title;
  final String? number;
  final IconData icon;
  final Color color;

  const EmergencyCardList({
    super.key,
    required this.title,
    required this.number,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          number ?? "-",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call_rounded, color: Color(0xFF66BB6A)),
          onPressed: number != null ? () => _makePhoneCall(context, number!) : null,
        ),
        onTap: number != null ? () => _makePhoneCall(context, number!) : null,
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String number) async {
    final telUrl = "tel:$number";
    final launched = await launchUrlString(telUrl, mode: LaunchMode.externalApplication);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak bisa membuka dialer")),
      );
    }
  }
}
