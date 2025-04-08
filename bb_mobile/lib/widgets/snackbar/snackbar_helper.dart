import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool hasBottomNavbar = true,
  }) {
    if (!context.mounted) return;

    final List<Color> gradientColors = isError
        ? [Colors.red.shade700, Colors.red.shade400]
        : [const Color(0xFF66BB6A), const Color(0xFF81C784)];

    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return _AnimatedSnackbar(
          message: message,
          gradientColors: gradientColors,
          hasBottomNavbar: hasBottomNavbar,
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}


class _AnimatedSnackbar extends StatefulWidget {
  final String message;
  final List<Color> gradientColors;
  final bool hasBottomNavbar;

  const _AnimatedSnackbar({
    required this.message,
    required this.gradientColors,
    required this.hasBottomNavbar,
  });

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _controller.reverse();
    });
  }

  void _dismiss() {
    if (mounted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.of(context).padding.bottom;
    final double bottomOffset = widget.hasBottomNavbar ? mediaPadding + 65 : mediaPadding + 10;

    return Positioned(
      bottom: bottomOffset,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
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
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _dismiss,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
