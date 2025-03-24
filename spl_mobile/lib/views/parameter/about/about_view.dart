import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/public/parameter_provider.dart';
import 'package:spl_mobile/views/parameter/about/components/about_data_empty_state.dart';
import 'package:spl_mobile/views/parameter/about/components/about_data_state.dart';
import 'package:spl_mobile/views/parameter/about/components/about_topbar.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
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
      appBar: const AboutTopBar(title: "Tentang Aplikasi"),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : parameter == null
                  ? const AboutDataEmptyState()
                  : AboutDataState(parameter: parameter),
    );
  }
}
