import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/parameter_provider.dart';
import 'components/emergency_topbar.dart';
import 'components/emergency_card_list.dart';

class EmergencyView extends StatefulWidget {
  const EmergencyView({super.key});

  @override
  State<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends State<EmergencyView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ParameterProvider>(context, listen: false).fetchParameter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParameterProvider>(context);
    final param = provider.parameter;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EmeregencyTopBar(title: "Kontak Darurat"),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : param == null
                  ? const Center(child: Text("Data kontak darurat tidak tersedia."))
                  : ListView(
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
                    ),
    );
  }
}
