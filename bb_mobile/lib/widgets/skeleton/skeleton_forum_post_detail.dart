import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ForumDetailSkeleton extends StatelessWidget {
  const ForumDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Postingan"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildUserInfo(),
                    const SizedBox(height: 12),
                    _buildContentText(),
                    const SizedBox(height: 12),
                    _buildImageGrid(),
                    const SizedBox(height: 12),
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    _buildCommentList(),
                  ],
                ),
              ),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({double width = double.infinity, double height = 12, BorderRadius? radius}) {
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

  Widget _buildUserInfo() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CircleAvatar(radius: 20, backgroundColor: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(width: 100, height: 12),
            const SizedBox(height: 6),
            _buildShimmerBox(width: 60, height: 10),
          ],
        ),
      ],
    );
  }

  Widget _buildContentText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildShimmerBox(height: 12),
      )),
    );
  }

  Widget _buildImageGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(3, (index) => _buildShimmerBox(width: 100, height: 100, radius: BorderRadius.circular(12))),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) => _buildShimmerBox(width: 80, height: 20, radius: BorderRadius.circular(20))),
    );
  }

  Widget _buildCommentList() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(radius: 16, backgroundColor: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: 80, height: 10),
                    const SizedBox(height: 4),
                    _buildShimmerBox(width: double.infinity, height: 12),
                    const SizedBox(height: 4),
                    _buildShimmerBox(width: 200, height: 12),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildShimmerBox(height: 36, radius: BorderRadius.circular(24))),
          const SizedBox(width: 8),
          _buildShimmerBox(width: 36, height: 36, radius: BorderRadius.circular(20)),
        ],
      ),
    );
  }
}
