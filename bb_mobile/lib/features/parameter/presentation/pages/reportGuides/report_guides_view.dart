import 'package:bb_mobile/features/parameter/presentation/pages/reportGuides/components/terms_data_empty_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/reportGuides/components/terms_data_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/reportGuides/components/terms_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';

class ReportGuidesView extends ConsumerStatefulWidget {
  const ReportGuidesView({super.key});

  @override
  ConsumerState<ReportGuidesView> createState() => _ReportGuidesViewState();
}

class _ReportGuidesViewState extends ConsumerState<ReportGuidesView> {
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
      appBar: const ReportGuidesTopBar(title: "Panduan Pelaporan"),
      body: parameterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("❌ $err")),
        data: (parameter) {
          if (parameter.reportGuidelines == null || parameter.reportGuidelines!.isEmpty) {
            return const ReportGuidesDataEmptyState();
          } else {
            return ReportGuidesDataState(content: parameter.reportGuidelines!);
          }
        },
      ),
    );
  }
}
