// lib/services/notification_service.dart
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Stream for notification taps
  Stream<Map<String, dynamic>> get onNotificationTapped =>
      _notificationStreamController.stream;

  // Initialize notification services
  Future<void> init() async {
    // Initialize timezone data for scheduled notifications
    tz_data.initializeTimeZones();

    // Initialize Firebase Messaging
    await _initFirebaseMessaging();

    // Initialize local notifications
    await _initLocalNotifications();

    // Listen for notification tap events
    _setupNotificationTapAction();
  }

  // Initialize Firebase Cloud Messaging
  Future<void> _initFirebaseMessaging() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission for FCM notifications');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission for FCM notifications');
    } else {
      log('User declined or has not accepted permission for FCM notifications');
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    log('FCM Token: $token');

    // Save token to local storage
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
        showLocalNotification(
          id: message.hashCode,
          title: message.notification?.title ?? 'Event Countdown',
          body: message.notification?.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('Handling a background message: ${message.messageId}');
    // Background notifications are handled by the system
  }

  // Initialize local notifications
  Future<void> _initLocalNotifications() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          // Removed onDidReceiveLocalNotification as it is no longer supported
        );

    // Initialize settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize plugin
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  // Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    // Events channel
    const AndroidNotificationChannel eventsChannel = AndroidNotificationChannel(
      'events_channel',
      'Events Notifications',
      description: 'This channel is used for event-related notifications',
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      playSound: true,
    );

    // Pomodoro channel
    const AndroidNotificationChannel pomodoroChannel =
        AndroidNotificationChannel(
          'pomodoro_channel',
          'Pomodoro Notifications',
          description: 'This channel is used for Pomodoro timer notifications',
          importance: Importance.high,
          enableVibration: true,
          enableLights: true,
          playSound: true,
        );

    // Daily reminder channel
    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
          'reminder_channel',
          'Daily Reminders',
          description: 'This channel is used for daily reminder notifications',
          importance: Importance.defaultImportance,
          enableVibration: true,
          playSound: true,
        );

    // Create the channels
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(eventsChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(pomodoroChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(reminderChannel);
  }

  // Handle iOS notification when app is in foreground (iOS < 10)
  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    log('Received iOS notification in foreground: $title');
    if (payload != null) {
      _notificationStreamController.add({'payload': payload});
    }
  }

  // Handle notification response (when user taps notification)
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      log('Notification payload: ${response.payload}');
      _notificationStreamController.add({'payload': response.payload});
    }
  }

  // Setup notification tap action to be detected in app
  void _setupNotificationTapAction() {
    // Check if app was opened from a notification
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        log('App was opened from a terminated state by notification');
        _notificationStreamController.add({
          'payload': message.data.toString(),
          'wasTerminated': true,
        });
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App was opened from a background state by notification');
      _notificationStreamController.add({
        'payload': message.data.toString(),
        'wasBackground': true,
      });
    });
  }

  // Show local notification immediately
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'events_channel',
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'events_channel',
          'Events Notifications',
          channelDescription:
              'This channel is used for event-related notifications',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  // Schedule a local notification at a specific date/time
  Future<void> scheduleEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'events_channel',
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          channelId == 'events_channel'
              ? 'Events Notifications'
              : 'Pomodoro Notifications',
          channelDescription: 'This channel is used for notifications',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convert to timezone-aware DateTime
    final scheduledTzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // Schedule notification
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTzDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      payload: payload,
    );
  }

  // Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
    String? payload,
    String channelId = 'reminder_channel',
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          'Daily Reminders',
          channelDescription:
              'This channel is used for daily reminder notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Create timezone-aware DateTime for today at the specified time
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the time is in the past for today, schedule for tomorrow
    tz.TZDateTime scheduledTzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    if (scheduledTzDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledTzDate = scheduledTzDate.add(const Duration(days: 1));
    }

    // Schedule daily notification
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTzDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,

      payload: payload,
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Cancel all event notifications for a specific event
  Future<void> cancelEventNotifications(String eventId) async {
    // Since we can't query scheduled notifications, we need to cancel by ID
    // We use the eventId hashCode as the base for notification IDs
    final baseId = eventId.hashCode;

    // Cancel the main notification
    await _localNotifications.cancel(baseId);

    // Cancel potential reminder notifications (we use a range of IDs)
    for (int i = 1; i <= 10; i++) {
      await _localNotifications.cancel(baseId + i);
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Dispose resources
  void dispose() {
    _notificationStreamController.close();
  }
}
