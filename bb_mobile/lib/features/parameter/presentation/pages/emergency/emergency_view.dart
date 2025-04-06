import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';
import 'components/emergency_card_list.dart';
import 'components/emergency_topbar.dart';

class EmergencyView extends ConsumerStatefulWidget {
  const EmergencyView({super.key});

  @override
  ConsumerState<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends ConsumerState<EmergencyView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(parameterNotifierProvider.notifier).fetchParameter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parameterAsync = ref.watch(parameterNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EmeregencyTopBar(title: "Kontak Darurat"),
      body: parameterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("❌ $err")),
        data: (param) {
          if (param.emergencyContact == null &&
              param.ambulanceContact == null &&
              param.policeContact == null &&
              param.firefighterContact == null) {
            return const Center(child: Text("Tidak ada data kontak darurat."));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EmergencyCardList(
                title: "Darurat Umum",
                number: param.emergencyContact,
                icon: Icons.warning_amber_rounded,
                color: Colors.redAccent,
              ),
              EmergencyCardList(
                title: "Ambulans",
                number: param.ambulanceContact,
                icon: Icons.local_hospital,
                color: Colors.teal,
              ),
              EmergencyCardList(
                title: "Polisi",
                number: param.policeContact,
                icon: Icons.local_police,
                color: Colors.blue,
              ),
              EmergencyCardList(
                title: "Pemadam Kebakaran",
                number: param.firefighterContact,
                icon: Icons.fire_extinguisher,
                color: Colors.deepOrange,
              ),
            ],
          );
        },
      ),
    );
  }
}
