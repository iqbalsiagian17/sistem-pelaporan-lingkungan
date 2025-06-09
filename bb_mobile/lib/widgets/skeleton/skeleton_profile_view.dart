import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileViewSkeleton extends StatelessWidget {
  const ProfileViewSkeleton();

  Widget _shimmerBox({double height = 14, double width = 100}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto profil
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 120, height: 18),
                    const SizedBox(height: 6),
                    _shimmerBox(width: 100),
                    const SizedBox(height: 6),
                    _shimmerBox(width: 160),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30),

          // Statistik
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _shimmerBox(width: 20, height: 16),
                    const SizedBox(height: 6),
                    _shimmerBox(width: 60, height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Menu
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(width: 24, height: 24, color: Colors.white),
                  const SizedBox(width: 16),
                  _shimmerBox(width: 120),
                  const Spacer(),
                  Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
