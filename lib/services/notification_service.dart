import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Иницијализирај timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
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
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Побарај дозвола за нотификации
    await _requestPermissions();

    // Конфигурирај Firebase Messaging
    await _configureFCM();
  }

  // Побарај дозволи
  Future<void> _requestPermissions() async {
    // Firebase Messaging дозвола
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Android 13+ дозвола за нотификации
    // За версија 15.x, дозволата се бара автоматски преку Firebase Messaging
    // Не е потребен посебен повик за Android local notifications
  }

  // Конфигурација на Firebase Cloud Messaging
  Future<void> _configureFCM() async {
    // Земи FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Слушај foreground пораки
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Слушај background пораки
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Провери дали има notification што ја отворила апликацијата
    RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  // Прикажи нотификација од foreground
  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _showNotification(
        id: message.hashCode,
        title: notification.title ?? 'TheMeal Recipes',
        body: notification.body ?? 'You have a new recipe!',
      );
    }
  }

  // Handle background message tap
  void _handleBackgroundMessage(RemoteMessage message) {
    print('Background message tapped: ${message.messageId}');
    // Тука можете да додадете навигација до специфичен екран
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Тука можете да додадете навигација до специфичен екран
  }

  // Прикажи едноставна нотификација
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_recipe_channel',
      'Daily Recipe',
      channelDescription: 'Daily recipe reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // Закажи дневна нотификација (на пр. секој ден во 10:00)
  Future<void> scheduleDailyRecipeNotification() async {
    await _localNotifications.zonedSchedule(
      0, // notification id
      'Recipe of the Day! 🍽️',
      'Discover a delicious random recipe today!',
      _nextInstanceOfTime(10, 0), // 10:00 AM
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe',
          channelDescription: 'Daily recipe reminders at 10:00 AM',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Пресметај следно време за нотификација
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Ако времето помина денес, закажи за утре
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Откажи ги сите нотификации
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Откажи специфична нотификација
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}

// Background message handler (мора да биде top-level функција)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}