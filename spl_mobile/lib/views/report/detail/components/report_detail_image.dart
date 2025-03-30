import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spl_mobile/providers/report/report_likes_provider.dart';
import 'package:spl_mobile/widgets/skeleton/skeleton_image_card.dart';

class ReportDetailImage extends StatefulWidget {
  final List<String> imageUrls;
  final int reportId;

  const ReportDetailImage({
    super.key,
    required this.imageUrls,
    required this.reportId,
  });

  @override
  _ReportDetailImageState createState() => _ReportDetailImageState();
}

class _ReportDetailImageState extends State<ReportDetailImage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReportLikeProvider>(context, listen: false)
          .fetchLikeStatus(widget.reportId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.imageUrls.isNotEmpty ? widget.imageUrls.length : 1,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                String imageUrl = widget.imageUrls.isNotEmpty
                    ? widget.imageUrls[index]
                    : "assets/images/default.jpg";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => _showFullImageDialog(context, imageUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: imageUrl,
                        child: imageUrl.startsWith("http")
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SkeletonImageCard(
                                  height: 200,
                                  borderRadius: 12,
                                  margin: EdgeInsets.zero,
                                ),
                                errorWidget: (context, url, error) => _defaultImage(),
                              )
                            : _defaultImage(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.imageUrls.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
                radius: 16,
                dotColor: Colors.grey,
                activeDotColor: Color(0xFF1976D2),
                expansionFactor: 4,
              ),
            ),
          ),
      ],
    );
  }

  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Hero(
          tag: imageUrl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: CachedNetworkImageProvider(imageUrl),
              width: double.infinity,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultImage() {
    return Image.asset(
      "assets/images/default.jpg",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
