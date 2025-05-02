import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../models/daily_tracker_model.dart';

class FirebaseDataSource {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Collection references
  CollectionReference get _usersCollection =>
      _firestore.collection(AppConstants.usersCollection);

  CollectionReference get _eventsCollection =>
      _firestore.collection(AppConstants.eventsCollection);

  CollectionReference get _trackersCollection =>
      _firestore.collection(AppConstants.trackersCollection);

  // Auth methods

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Auth state changes stream
  Stream<bool> authStateChanges() {
    return _auth.authStateChanges().map((user) => user != null);
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User methods

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  // Create user document
  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.id).set(user.toFirestore());
  }

  // Update user document
  Future<void> updateUser(UserModel user) async {
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }

  // Update FCM token for user
  Future<void> updateFcmToken(String userId, String token) async {
    await _usersCollection.doc(userId).update({
      'fcmToken': token,
      'updatedAt': Timestamp.now(),
    });
  }

  // Event methods

  // Get all events for user
  Stream<List<EventModel>> getEvents(String userId) {
    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('eventDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get upcoming events for user
  Stream<List<EventModel>> getUpcomingEvents(String userId) {
    final now = DateTime.now();

    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('eventDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    final doc = await _eventsCollection.doc(eventId).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

  // Add new event
  Future<DocumentReference> addEvent(EventModel event) async {
    return await _eventsCollection.add(event.toFirestore());
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    await _eventsCollection.doc(event.id).update(event.toFirestore());
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  // Mark event as completed
  Future<void> markEventAsCompleted(String eventId, bool isCompleted) async {
    await _eventsCollection.doc(eventId).update({
      'isCompleted': isCompleted,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Daily tracker methods

  // Get tracker by date for user
  Future<DailyTrackerModel?> getTrackerByDate(
    String userId,
    DateTime date,
  ) async {
    final formattedDate = DateTime(date.year, date.month, date.day);
    final startOfDay = Timestamp.fromDate(formattedDate);
    final endOfDay = Timestamp.fromDate(
      formattedDate
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1)),
    );

    final querySnapshot = await _trackersCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return DailyTrackerModel.fromFirestore(querySnapshot.docs.first);
  }

  // Get trackers for date range
  Future<List<DailyTrackerModel>> getTrackersByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    final querySnapshot = await _trackersCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThan: endTimestamp)
        .orderBy('date')
        .get();

    return querySnapshot.docs
        .map((doc) => DailyTrackerModel.fromFirestore(doc))
        .toList();
  }

  // Create tracker
  Future<DocumentReference> createTracker(DailyTrackerModel tracker) async {
    return await _trackersCollection.add(tracker.toFirestore());
  }

  // Update tracker
  Future<void> updateTracker(DailyTrackerModel tracker) async {
    await _trackersCollection.doc(tracker.id).update(tracker.toFirestore());
  }

  // Update specific tracker field
  Future<void> updateTrackerField(
    String trackerId,
    String field,
    dynamic value,
  ) async {
    await _trackersCollection.doc(trackerId).update({
      field: value,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Messaging methods

  // Request notification permissions
  Future<NotificationSettings> requestNotificationPermissions() async {
    return await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // Get FCM token
  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
