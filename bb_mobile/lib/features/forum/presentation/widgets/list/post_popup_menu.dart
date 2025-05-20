import 'package:bb_mobile/core/services/auth/global_auth_service.dart';
import 'package:bb_mobile/features/forum/domain/entities/forum_post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalAuthServiceProvider = Provider((ref) => GlobalAuthService());

class PostPopupMenu extends ConsumerStatefulWidget {
  final ForumPostEntity post;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  const PostPopupMenu({
    super.key,
    required this.post,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<PostPopupMenu> createState() => _PostPopupMenuState();
}

class _PostPopupMenuState extends ConsumerState<PostPopupMenu> {
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final authService = ref.read(globalAuthServiceProvider);
    final id = await authService.getUserId();
    if (!mounted) return;
    setState(() {
      _userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _userId == widget.post.user.id;
    if (!isOwner) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          widget.onEdit?.call();
        } else if (value == 'delete') {
          _showDeleteConfirmationSheet(context);
        }
      },
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 2,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit_outlined, color: Colors.blue),
              SizedBox(width: 10),
              Text("Edit Postingan"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 10),
              Text("Hapus Postingan"),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmationSheet(BuildContext context) async {
    HapticFeedback.mediumImpact();

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              "Konfirmasi Hapus",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Apakah Anda yakin ingin menghapus postingan ini? Aksi ini tidak dapat dibatalkan.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                    child: const Text("Batal", style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () async {
                      Navigator.pop(context);
                      await widget.onDelete?.call();
                    },
                    child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
