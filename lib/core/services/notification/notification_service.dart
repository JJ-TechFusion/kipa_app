import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kipa/main.dart';
import 'package:kipa/utils/constant.dart';
import 'notification_types.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logMessage('NotificationService', 'Background message: ${message.data}');
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'kipa_notifications',
    'Kipa Notifications',
    description: 'Notifications from Kipa',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    await _requestPermissions();
    await _setupLocalNotifications();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          logMessage('NotificationService', 'APNs token not yet available');
          return null;
        }
      }
      final token = await _messaging.getToken();
      logMessage('NotificationService', 'FCM Token: $token');
      return token;
    } catch (e) {
      logMessage('NotificationService', 'Error getting FCM token: $e');
      return null;
    }
  }

  void onTokenRefresh(Function(String) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }

  String get platform => Platform.isIOS ? 'ios' : 'android';

  void _handleForegroundMessage(RemoteMessage message) {
    logMessage('NotificationService', 'Foreground message: ${message.data}');

    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    logMessage('NotificationService', 'Notification tapped: ${message.data}');

    final payload = NotificationPayload.fromMap(
      message.data,
      title: message.notification?.title,
      body: message.notification?.body,
    );

    _navigateFromPayload(payload);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    logMessage(
      'NotificationService',
      'Local notification tapped: ${response.payload}',
    );
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        final payload = NotificationPayload.fromMap(data);
        _navigateFromPayload(payload);
      } catch (e) {
        logMessage(
          'NotificationService',
          'Error parsing notification payload: $e',
        );
      }
    }
  }

  void _navigateFromPayload(NotificationPayload payload) {
    final route = payload.targetRoute;
    if (route == null) return;

    final context = navigatorKey.currentState;
    if (context == null) return;

    context.pushNamed(route, arguments: payload.targetArguments);
  }
}
