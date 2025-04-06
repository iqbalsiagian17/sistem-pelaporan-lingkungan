import 'package:bb_mobile/features/parameter/presentation/pages/about/components/about_data_empty_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/about/components/about_data_state.dart';
import 'package:bb_mobile/features/parameter/presentation/pages/about/components/about_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/parameter/presentation/providers/parameter_provider.dart';

class AboutView extends ConsumerStatefulWidget {
  const AboutView({super.key});

  @override
  ConsumerState<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends ConsumerState<AboutView> {
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
      appBar: const AboutTopBar(title: "Tentang Aplikasi"),
      body: parameterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("❌ $err")),
        data: (parameter) {
          if (parameter.about == null || parameter.about!.isEmpty) {
            return const AboutDataEmptyState();
          } else {
            return AboutDataState(content: parameter.about!);
          }
        },
      ),
    );
  }
}
