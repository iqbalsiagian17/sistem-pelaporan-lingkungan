import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background handler untuk ketika notifikasi ditekan saat app ditutup
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('🔕 [Background] Notifikasi ditekan: ${response.payload}');
}

Future<void> setupFirebaseMessaging() async {
  // 🔧 Inisialisasi Firebase
  await Firebase.initializeApp();

  // 🔔 Minta izin notifikasi
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

  print('🔔 Izin notifikasi: ${settings.authorizationStatus}');

  // 📲 Dapatkan token FCM
  final token = await FirebaseMessaging.instance.getToken();
  print("📲 Token FCM: $token");

  // 🔧 Inisialisasi notifikasi lokal (foreground)
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("🔔 Notifikasi ditekan: ${response.payload}");
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // 🔔 Buat channel notifikasi penting
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'Notifikasi Penting', // Nama
    description: 'Channel untuk notifikasi penting',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Tangani notifikasi saat app sedang aktif (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔔 Pesan FCM diterima saat foreground");
    print("📦 Payload: ${message.data}");
    print("🧾 Notifikasi: ${message.notification}");

    if (message.notification != null) {
      final notification = message.notification!;
      final android = notification.android;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? 'Judul Kosong',
        notification.body ?? 'Isi Kosong',
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
    } else if (message.data.isNotEmpty) {
      // fallback jika message.notification null
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.data['title'] ?? 'Notifikasi',
        message.data['body'] ?? 'Pesan baru masuk',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notifikasi Penting',
            channelDescription: 'Channel untuk notifikasi penting',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } else {
      print("⚠️ Tidak ada notifikasi dan data.");
    }
  });
}
