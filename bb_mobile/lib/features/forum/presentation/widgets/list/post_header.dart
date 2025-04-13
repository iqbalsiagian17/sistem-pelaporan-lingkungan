import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/date_utils.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_popup_menu.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final ForumPostEntity post;
  final VoidCallback? onUserTap;

  const PostHeader({
    super.key,
    required this.post,
    this.onUserTap,
  });

  String _getInitial(String username) {
    return username.isNotEmpty ? username[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = post.user.profilePicture != null &&
        post.user.profilePicture!.isNotEmpty;

    final profileUrl = hasImage
        ? "${ApiConstants.baseUrl}/${post.user.profilePicture!.replaceAll(r'\', '/')}"
        : null;

    return Row(
      children: [
        GestureDetector(
          onTap: onUserTap,
          child: ClipOval(
            child: hasImage
                ? Image.network(
                    profileUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildInitialAvatar(post.user.username),
                  )
                : _buildInitialAvatar(post.user.username),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onUserTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "• ${DateUtilsCustom.timeAgo(DateTime.parse(post.createdAt))}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        PostPopupMenu(post: post),
      ],
    );
  }

  Widget _buildInitialAvatar(String username) {
    final initial = _getInitial(username);
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
