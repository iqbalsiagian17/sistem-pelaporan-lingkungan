import 'package:flutter/material.dart';

class GlobalRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const GlobalRefreshWrapper({
    super.key,
    required this.child,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {}, // Default jika tidak ada fungsi refresh
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}
