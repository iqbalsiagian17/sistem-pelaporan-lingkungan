import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:bb_mobile/routes/app_routes.dart'; // ✅ Import route

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late GoRouter _router;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('🔕 [Background] Notifikasi ditekan: ${response.payload}');
  // Navigasi tidak bisa langsung dari isolate, bisa disimpan ke storage lalu ditangani saat resume
}

Future<void> setupFirebaseMessaging(GoRouter router) async {
  _router = router;

  await Firebase.initializeApp();

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  debugPrint('🔔 Izin notifikasi: ${settings.authorizationStatus}');

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint("📲 Token FCM: $token");

  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      debugPrint("🔔 Notifikasi ditekan (foreground/background): $payload");
      if (payload == AppRoutes.notification) {
        _router.go(AppRoutes.notification);
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifikasi Penting',
    description: 'Channel untuk notifikasi penting',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;
    final title = notification?.title ?? data['title'] ?? 'Notifikasi';
    final body = notification?.body ?? data['body'] ?? 'Ada pesan baru';
    final route = data['route'] ?? AppRoutes.notification; // ✅ default ke /notification

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Notifikasi Penting',
          channelDescription: 'Channel untuk notifikasi penting',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: route,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final route = message.data['route'];
    if (route != null) {
      _router.go('/$route');
    }
  });
}
