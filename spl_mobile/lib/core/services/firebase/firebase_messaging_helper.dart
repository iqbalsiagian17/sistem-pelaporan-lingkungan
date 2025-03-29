import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> setupFirebaseMessaging() async {
  await Firebase.initializeApp();

  // ✅ Minta izin notifikasi (Android 13+ dan iOS)
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  print('🔔 Notifikasi izin: ${settings.authorizationStatus}');

  // ✅ Ambil token FCM
  final token = await FirebaseMessaging.instance.getToken();
  print("📲 FCM Token (sementara): $token");

  // ✅ Handle notifikasi saat app aktif
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔔 Notifikasi diterima saat app aktif (foreground)");
    if (message.notification != null) {
      print("🔸 Title: ${message.notification!.title}");
      print("🔸 Body: ${message.notification!.body}");
    }
  });
}
