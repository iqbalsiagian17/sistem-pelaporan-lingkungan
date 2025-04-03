import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/features/auth/data/datasources/auth_google_datasource.dart';

final googleAuthProvider =
    StateNotifierProvider<GoogleAuthNotifier, AsyncValue<bool>>((ref) {
  return GoogleAuthNotifier(AuthGoogleDataSourceImpl());
});

class GoogleAuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthGoogleDataSource authGoogleDataSource;

  GoogleAuthNotifier(this.authGoogleDataSource) : super(const AsyncValue.data(false));

  Future<bool> loginWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await authGoogleDataSource.loginWithGoogle();
    if (result.containsKey("error")) {
      state = AsyncValue.error(result["error"], StackTrace.current);
      return false;
    }

    state = const AsyncValue.data(true);
    return true;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await authGoogleDataSource.logoutFromGoogle();
    state = const AsyncValue.data(false);
  }
}
