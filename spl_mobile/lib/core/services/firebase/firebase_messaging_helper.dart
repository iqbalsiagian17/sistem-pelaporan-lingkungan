import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFirebaseMessaging() async {
  await Firebase.initializeApp();

  // 🔔 Request permission
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  print('🔔 Notifikasi izin: ${settings.authorizationStatus}');

  // 📲 Ambil token FCM
  final token = await FirebaseMessaging.instance.getToken();
  print("📲 Token FCM: $token");

  // 🔧 Setup notifikasi lokal (dibutuhkan saat app di foreground)
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // ✅ Konfigurasi channel notifikasi
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'Notifikasi Penting', // Nama channel
    description: 'Channel untuk notifikasi penting',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Saat pesan masuk saat app aktif (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔔 Pesan diterima saat foreground");

    if (message.notification != null) {
      final notification = message.notification!;
      final android = message.notification!.android;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
}
