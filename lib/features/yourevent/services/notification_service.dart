// lib/services/notification_service.dart
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

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

    // Initialize Awesome Notifications
    await _initAwesomeNotifications();

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

  // Initialize Awesome Notifications
  Future<void> _initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      // Set null to use the default app icon
      'resource://drawable/ic_launcher',
      [
        // Events channel
        NotificationChannel(
          channelKey: 'events_channel',
          channelName: 'Events Notifications',
          channelDescription:
              'This channel is used for event-related notifications',
          defaultColor: Colors.purple,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
        ),
        // Pomodoro channel
        NotificationChannel(
          channelKey: 'pomodoro_channel',
          channelName: 'Pomodoro Notifications',
          channelDescription:
              'This channel is used for Pomodoro timer notifications',
          defaultColor: Colors.red,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
        ),
        // Daily reminder channel
        NotificationChannel(
          channelKey: 'reminder_channel',
          channelName: 'Daily Reminders',
          channelDescription:
              'This channel is used for daily reminder notifications',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // Setup notification tap action to be detected in app
  void _setupNotificationTapAction() {
    // Listen for notification tap events - use the correct API method
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreatedMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );

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

  // Awesome Notifications action handlers
  @pragma("vm:entry-point")
  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Forward notification action to the singleton instance
    if (receivedAction.payload != null) {
      log('Notification action received: ${receivedAction.payload}');
      NotificationService._instance._notificationStreamController.add({
        'payload': receivedAction.payload.toString(),
        'actionType': receivedAction.actionType.toString(),
      });
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> _onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log('Notification displayed: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> _onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log('Notification dismissed: ${receivedAction.id}');
  }

  // Show local notification immediately
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'events_channel',
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelId,
        title: title,
        body: body,
        payload: payload != null ? {'data': payload} : null,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Schedule a notification
  Future<void> scheduleEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'events_channel',
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelId,
        title: title,
        body: body,
        payload: payload != null ? {'data': payload, 'eventId': payload} : null,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
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
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelId,
        title: title,
        body: body,
        payload: payload != null ? {'data': payload} : null,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // Cancel all event notifications for a specific event
  Future<void> cancelEventNotifications(String eventId) async {
    // Since we can't query scheduled notifications, we need to cancel by ID
    // We use the eventId hashCode as the base for notification IDs
    final baseId = eventId.hashCode;

    // Cancel the main notification
    await AwesomeNotifications().cancel(baseId);

    // Cancel potential reminder notifications (we use a range of IDs)
    for (int i = 1; i <= 10; i++) {
      await AwesomeNotifications().cancel(baseId + i);
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // Dispose resources
  void dispose() {
    // No need to manually close action streams anymore
    _notificationStreamController.close();
  }
}
