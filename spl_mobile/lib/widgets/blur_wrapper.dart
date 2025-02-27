import 'dart:ui';
import 'package:flutter/material.dart';

class BlurWrapper extends StatefulWidget {
  final Widget child;

  const BlurWrapper({super.key, required this.child});

  @override
  State<BlurWrapper> createState() => _BlurWrapperState();
}

class _BlurWrapperState extends State<BlurWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Pantau lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hapus observer saat widget dihapus
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBlurred = state == AppLifecycleState.paused || state == AppLifecycleState.inactive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBlurred)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2), // Lapisan semi-transparan
              ),
            ),
          ),
      ],
    );
  }
}
