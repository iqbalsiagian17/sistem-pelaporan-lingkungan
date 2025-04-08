import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';
import 'package:bb_mobile/core/constants/api.dart';

Future<void> saveFcmTokenToBackend(int userId) async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    print("📲 Token FCM yang akan dikirim: $token");

    if (token == null) return;

    final dio = DioClient.instance;

    final response = await dio.post(
      "${ApiConstants.userNotificationUrl}/fcm-token",
      data: {
        'user_id': userId,
        'fcm_token': token,
      },
    );

    print("Token FCM berhasil dikirim ke backend: ${response.data}");
  } catch (e) {
    print("Gagal mengirim token FCM ke backend: $e");
  }
}
