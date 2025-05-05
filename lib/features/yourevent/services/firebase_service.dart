// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Messaging instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Expose instances
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseMessaging get messaging => _messaging;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Initialize Firebase Messaging
  Future<void> initMessaging() async {
    // Request permission for notifications
    // ignore: unused_local_variable
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    String? token = await _messaging.getToken();

    // Save token to user's document in Firestore
    if (token != null && isAuthenticated) {
      await _firestore.collection('users').doc(currentUserId).update({
        'fcmToken': token,
      });
    }

    // Handle incoming messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground message
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show local notification
      }
    });
  }

  /// Checks if the current user is a premium user.
  ///
  /// Returns [true] if the user is a premium user, [false] otherwise.
  Future<bool> isPremuimUser() async {
    final docSnapshot =
        await _firestore.collection('users').doc(currentUserId).get();
    return docSnapshot['premiumUser'] ?? false;
  }
}
