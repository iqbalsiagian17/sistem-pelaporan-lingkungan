import 'package:bb_mobile/core/constants/api.dart';
import 'package:bb_mobile/core/utils/date_utils.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/post_popup_menu.dart';
import 'package:bb_mobile/features/forum/presentation/widgets/list/user_profile_modal.dart';
import 'package:flutter/material.dart';

class ForumUserInfo extends StatelessWidget {
  final ForumPostEntity post;
  final VoidCallback? onEditTap;
  final Future<void> Function()? onDeleteTap;

  const ForumUserInfo({
    super.key,
    required this.post,
    this.onEditTap,
    this.onDeleteTap,
  });

  String getFullImageUrl(String path) {
    return "${ApiConstants.baseUrl}/${path.replaceAll(r'\', '/')}";
  }

  void _showUserModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserProfileModal(user: post.user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = post.user.profilePicture;
    final hasImage = profileUrl != null && profileUrl.isNotEmpty;
    final imageUrl = hasImage ? getFullImageUrl(profileUrl) : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// 🟢 Avatar
        GestureDetector(
          onTap: () => _showUserModal(context),
          child: ClipOval(
            child: hasImage
                ? Image.network(
                    imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildInitialAvatar(post.user.username),
                  )
                : _buildInitialAvatar(post.user.username),
          ),
        ),
        const SizedBox(width: 12),

        /// 🟢 Informasi User
        Expanded(
          child: GestureDetector(
            onTap: () => _showUserModal(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.username,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "@${post.user.username.toLowerCase()}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  "• ${DateUtilsCustom.timeAgo(DateTime.parse(post.createdAt))}${post.isEdited ? " (diubah)" : ""}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 🟢 Tombol Titik Tiga
        PostPopupMenu(
          post: post,
          onEdit: onEditTap,
          onDelete: onDeleteTap,
        ),
      ],
    );
  }

  Widget _buildInitialAvatar(String username) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : "?";
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color.fromARGB(255, 34, 143, 90),
      child: Text(
        initial,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
