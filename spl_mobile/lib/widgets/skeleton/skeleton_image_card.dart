import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonImageCard extends StatelessWidget {
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonImageCard({
    Key? key,
    this.height = 180,
    this.borderRadius = 16,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ❗ Full width
      height: height,         // ❗ Full height (default: 180)
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
