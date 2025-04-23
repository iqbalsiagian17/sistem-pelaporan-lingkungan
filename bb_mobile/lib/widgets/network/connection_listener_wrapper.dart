import 'dart:async';
import 'package:bb_mobile/core/utils/internet_checker.dart';
import 'package:bb_mobile/widgets/snackbar/snackbar_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionListenerWrapper extends StatefulWidget {
  final Widget child;

  const ConnectionListenerWrapper({super.key, required this.child});

  @override
  State<ConnectionListenerWrapper> createState() => _ConnectionListenerWrapperState();
}

class _ConnectionListenerWrapperState extends State<ConnectionListenerWrapper> {
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      final connected = await InternetChecker.hasConnection(); // ✅ cek aktual
      if (!connected) {
        SnackbarHelper.showSnackbar(
          context,
          "⚠️ Tidak ada koneksi internet",
          isError: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
