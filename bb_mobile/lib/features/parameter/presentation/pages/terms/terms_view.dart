import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_empty_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_data_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/terms/components/terms_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';

class TermsView extends ConsumerStatefulWidget {
  const TermsView({super.key});

  @override
  ConsumerState<TermsView> createState() => _TermsViewState();
}

class _TermsViewState extends ConsumerState<TermsView> {
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
      appBar: const TermsTopBar(title: "Syarat & Ketentuan"),
      body: parameterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("❌ $err")),
        data: (parameter) {
          if (parameter.terms == null || parameter.terms!.isEmpty) {
            return const TermsDataEmptyState();
          } else {
            return TermsDataState(content: parameter.terms!);
          }
        },
      ),
    );
  }
}
