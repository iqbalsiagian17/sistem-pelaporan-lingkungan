import 'package:flutter/material.dart';
import '../../../widgets/custom_chip.dart';

class TopicSection extends StatelessWidget {
  const TopicSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // ✅ Padding rapi
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Topik Aduan Populer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                CustomChip(label: '#TumpukanSampah'),
                CustomChip(label: '#SampahLiar'),
                CustomChip(label: '#TongPenuh'),
                CustomChip(label: '#BauTidakSedap'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
