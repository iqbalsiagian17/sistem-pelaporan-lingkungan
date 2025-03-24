import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/public/parameter_provider.dart';
import 'package:spl_mobile/views/parameter/terms/components/terms_data_empty_state.dart';
import 'package:spl_mobile/views/parameter/terms/components/terms_data_state.dart';
import 'package:spl_mobile/views/parameter/terms/components/terms_topbar.dart';

class TermsView extends StatefulWidget {
  const TermsView({super.key});

  @override
  State<TermsView> createState() => _TermsViewState();
}

class _TermsViewState extends State<TermsView> {
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
    final parameter = provider.parameter;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TermsTopBar(title: "Syarat dan Ketentuan"),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : parameter == null
                  ? const TermsDataEmptyState()
                  : TermsDataState(parameter: parameter),
    );
  }
}
