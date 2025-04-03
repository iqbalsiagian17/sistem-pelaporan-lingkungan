import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SafeBackWrapper extends StatelessWidget {
  final Widget child;

  const SafeBackWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return false;
        }

        final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Keluar Aplikasi"),
                content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Keluar", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ) ??
            false;

        return shouldExit;
      },
      child: child,
    );
  }
}
