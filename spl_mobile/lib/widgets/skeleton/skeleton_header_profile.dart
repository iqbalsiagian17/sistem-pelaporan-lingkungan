import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  Widget _shimmerBox({double width = double.infinity, double height = 12, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _shimmerBox(width: 120, height: 18, radius: BorderRadius.circular(6)), // username
        const SizedBox(height: 8),
        _shimmerBox(width: 160, height: 14, radius: BorderRadius.circular(6)), // phone
        const SizedBox(height: 6),
        _shimmerBox(width: 180, height: 14, radius: BorderRadius.circular(6)), // email
        const SizedBox(height: 12),
        _shimmerBox(width: 140, height: 28, radius: BorderRadius.circular(30)), // google badge
      ],
    );
  }
}
