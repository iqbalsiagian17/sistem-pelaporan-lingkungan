import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spl_mobile/providers/forum/forum_likes_provider.dart';

class ForumAction extends StatefulWidget {
  final int postId;
  final String token;
  final int userId;
  final int commentCount;

  const ForumAction({
    super.key,
    required this.postId,
    required this.token,
    required this.userId,
    required this.commentCount,
  });

  @override
  _ForumActionState createState() => _ForumActionState();
}

class _ForumActionState extends State<ForumAction> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  /// **🔄 Ambil Status Like**
  Future<void> _loadLikeStatus() async {
    final postLikeProvider = Provider.of<PostLikeProvider>(context, listen: false);

    if (mounted) {
      setState(() {
        _isLiked = postLikeProvider.isLiked(widget.userId, widget.postId);
        _likeCount = postLikeProvider.getLikeCount(widget.postId);
      });
    }
  }

  /// **❤️ Toggle Like/Unlike**
  Future<void> _toggleLike() async {
    final postLikeProvider = Provider.of<PostLikeProvider>(context, listen: false);

    if (_isLiked) {
      await postLikeProvider.unlikePost(widget.userId, widget.postId, widget.token);
    } else {
      await postLikeProvider.likePost(widget.userId, widget.postId, widget.token);
    }

    await postLikeProvider.fetchLikeCount(widget.postId, widget.token);

    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount = postLikeProvider.getLikeCount(widget.postId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // ✅ Jarak atas & bawah lebih proporsional
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // **Like (Diletakkan di kiri)**
              InkWell(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isLiked),
                        color: _isLiked ? Colors.red : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$_likeCount",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // **Komentar (Diletakkan di kanan)**
              Text(
                "${widget.commentCount} Komentar",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10), // ✅ Tambahkan jarak ke elemen bawah
        ],
      ),
    );
  }
}
