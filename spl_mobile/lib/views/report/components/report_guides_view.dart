import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Parameter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

class ReportGuides extends StatelessWidget {
  final ParameterItem? parameter; // ✅ nullable
  final bool isLoading;

  const ReportGuides({
    super.key,
    required this.parameter,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const _SkeletonGuides()
          : (parameter == null || parameter!.reportGuidelines == null)
              ? const Center(child: Text("Tata cara belum tersedia."))
              : SingleChildScrollView(
                  child: Html(
                    data: parameter!.reportGuidelines!,
                  ),
                ),
    );
  }
}

class _SkeletonGuides extends StatelessWidget {
  const _SkeletonGuides();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(4, (index) => _shimmerLine()),
    );
  }

  Widget _shimmerLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
