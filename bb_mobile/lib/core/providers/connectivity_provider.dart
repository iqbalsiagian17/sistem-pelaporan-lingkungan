import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider untuk stream perubahan status koneksi
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Provider boolean untuk menentukan apakah sedang offline
final isOfflineProvider = Provider<bool>((ref) {
  final result = ref.watch(connectivityProvider).value;
  return result == ConnectivityResult.none;
});
