import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spl_mobile/providers/user_report_likes_provider.dart';

class ReportDetailImage extends StatefulWidget {
  final List<String> imageUrls;
  final int reportId;
  final String token;

  const ReportDetailImage({
    super.key,
    required this.imageUrls,
    required this.reportId,
    required this.token,
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
          .fetchLikeStatus(widget.reportId, widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final likeProvider = Provider.of<ReportLikeProvider>(context);
    final bool isLiked = likeProvider.isLiked(widget.reportId);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
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
                                    progressIndicatorBuilder: (context, url, progress) {
                                      return _loadingPlaceholder();
                                    },
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
        ),

        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () async {
              if (isLiked) {
                await likeProvider.unlikeReport(widget.reportId, widget.token);
              } else {
                await likeProvider.likeReport(widget.reportId, widget.token);
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.7),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
                size: 26,
              ),
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


  // 🔹 Placeholder saat gambar benar-benar masih loading
  Widget _loadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    );
  }

  // 🔹 Gambar default jika tidak tersedia
  Widget _defaultImage() {
    return Image.asset(
      "assets/images/default.jpg",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
