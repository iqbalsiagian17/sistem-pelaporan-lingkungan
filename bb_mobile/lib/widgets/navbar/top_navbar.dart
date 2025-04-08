import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/features/notification/presentation/providers/notification_provider.dart';

class TopBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  ConsumerState<TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<TopBar> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshNotif();
  }

  void _refreshNotif() {
    final notifier = ref.read(notificationProvider.notifier);
    notifier.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotif();
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(notificationProvider.notifier).unreadCount;

    return AppBar(
      backgroundColor: const Color(0xFF66BB6A),
      title: const Text(
        "BaligeBersih",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      actions: [
        // 🔽 Tambah dropdown
        PopupMenuButton<int>(
        icon: const Icon(Icons.add, color: Colors.white),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        offset: const Offset(0, 45), // posisi pop-up sedikit di bawah icon
        onSelected: (value) {
          if (value == 0) {
            context.push('/create-report');
          } else if (value == 1) {
            context.push('/forum?openModal=create');
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: const [
                Icon(Icons.add, size: 20, color: Color(0xFF66BB6A)),
                SizedBox(width: 10),
                Text("Buat Aduan Baru"),
              ],
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: const [
                Icon(Icons.forum, size: 20, color: Color(0xFF66BB6A)),
                SizedBox(width: 10),
                Text("Buat Postingan Forum"),
              ],
            ),
          ),
        ],
      )
      ,

        // 🔔 Notifikasi dengan badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              color: Colors.white,
              onPressed: () => context.push('/notification'),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
