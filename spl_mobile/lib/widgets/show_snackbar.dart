import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar(BuildContext context, String message, {bool isError = false}) {
    final icon = isError ? Icons.error_outline_rounded : Icons.check_circle_rounded;
    final List<Color> gradientColors = isError
        ? [Colors.red.shade700, Colors.red.shade400] // 🔴 Gradient untuk error
        : [Color(0xFF4CAF50), Color(0xFF81C784)]; // ✅ Gradient hijau terang → hijau muda

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // ✅ Muncul di bawah status bar
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: -1, end: 0), // ✅ Animasi slide-in dari atas
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, value * 100),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors, // ✅ Gradient hijau terang → hijau muda
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 22), // ✅ Icon minimalis
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // ✅ Tambahkan overlay ke layar
    overlay.insert(overlayEntry);

    // ✅ Hapus dengan efek fade-out setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
