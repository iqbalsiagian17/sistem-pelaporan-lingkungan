import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/models/Parameter.dart';
import 'package:spl_mobile/providers/public/parameter_provider.dart';
import 'package:spl_mobile/views/report/components/report_guides_view.dart';
import 'components/report_topbar.dart';

class ReportGuidesView extends StatefulWidget {
  const ReportGuidesView({super.key});

  @override
  State<ReportGuidesView> createState() => _ReportGuidesViewState();
}

class _ReportGuidesViewState extends State<ReportGuidesView> {
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
