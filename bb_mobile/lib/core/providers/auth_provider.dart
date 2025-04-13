import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/services/auth/global_auth_service.dart';

final globalAuthServiceProvider = Provider<GlobalAuthService>((ref) {
  return globalAuthService..init(); // auto-init saat app start
});

