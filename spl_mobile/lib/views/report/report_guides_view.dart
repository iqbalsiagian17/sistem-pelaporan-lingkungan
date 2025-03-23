import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Parameter.dart';
import 'package:spl_mobile/providers/parameter_provider.dart';
import 'package:spl_mobile/views/report/components/report_guides_view.dart';
import 'components/report_topbar.dart';

class ReportGuidesView extends StatelessWidget {
  const ReportGuidesView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParameterProvider>(context);
    final ParameterItem? parameter = provider.parameter;
    final bool isLoading = provider.isLoading;

    return Scaffold(
      appBar: const ReportTopBar(title: "Tata Cara Pelaporan"),
      backgroundColor: Colors.white,
      body: ReportGuides(
        parameter: parameter,
        isLoading: isLoading,
      ),
    );
  }
}
