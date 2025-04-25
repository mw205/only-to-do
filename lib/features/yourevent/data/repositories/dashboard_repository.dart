import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/daily_tracker_model.dart';
import '../../services/firebase_service.dart';

class DashboardRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Reference to daily tracker collection
  CollectionReference get _trackersCollection =>
      _firebaseService.firestore.collection('daily_trackers');

  // Get today's tracker for current user
  Future<DailyTrackerModel?> getTodayTracker() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return null;

    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final querySnapshot =
        await _trackersCollection
            .where('userId', isEqualTo: userId)
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime.parse(formattedDate),
              ),
            )
            .where(
              'date',
              isLessThan: Timestamp.fromDate(
                DateTime.parse(formattedDate).add(const Duration(days: 1)),
              ),
            )
            .limit(1)
            .get();

    if (querySnapshot.docs.isEmpty) {
      // Create a new tracker for today
      return await createDailyTracker();
    }

    return DailyTrackerModel.fromFirestore(querySnapshot.docs.first);
  }

  // Get trackers for the past 7 days
  Future<List<DailyTrackerModel>> getWeekTrackers() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return [];

    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    final querySnapshot =
        await _trackersCollection
            .where('userId', isEqualTo: userId)
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo),
            )
            .orderBy('date', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => DailyTrackerModel.fromFirestore(doc))
        .toList();
  }

  // Get trackers for the past 30 days
  Future<List<DailyTrackerModel>> getMonthTrackers() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return [];

    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    final querySnapshot =
        await _trackersCollection
            .where('userId', isEqualTo: userId)
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo),
            )
            .orderBy('date', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => DailyTrackerModel.fromFirestore(doc))
        .toList();
  }

  // Create a new daily tracker
  Future<DailyTrackerModel> createDailyTracker() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final newTracker = DailyTrackerModel(
      id: '',
      userId: userId,
      date: today,
      createdAt: now,
      updatedAt: now,
    );

    final docRef = await _trackersCollection.add(newTracker.toFirestore());

    return newTracker.copyWith(id: docRef.id);
  }

  // Update daily tracker
  Future<void> updateDailyTracker(DailyTrackerModel tracker) async {
    final updatedTracker = tracker.copyWith(updatedAt: DateTime.now());

    await _trackersCollection
        .doc(tracker.id)
        .update(updatedTracker.toFirestore());
  }

  // Update sleep hours
  Future<void> updateSleepHours(String trackerId, int hours) async {
    if (hours < 0 || hours > 24) {
      throw Exception('Sleep hours must be between 0 and 24');
    }

    await _trackersCollection.doc(trackerId).update({
      'sleepHours': hours,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Update water intake
  Future<void> updateWaterIntake(String trackerId, int milliliters) async {
    if (milliliters < 0) {
      throw Exception('Water intake cannot be negative');
    }

    await _trackersCollection.doc(trackerId).update({
      'waterIntake': milliliters,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Update steps
  Future<void> updateSteps(String trackerId, int steps) async {
    if (steps < 0) {
      throw Exception('Steps cannot be negative');
    }

    await _trackersCollection.doc(trackerId).update({
      'steps': steps,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Toggle diet tracked
  Future<void> toggleDietTracked(String trackerId, bool tracked) async {
    await _trackersCollection.doc(trackerId).update({
      'dietTracked': tracked,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Add completed task
  Future<void> addCompletedTask(String trackerId, String task) async {
    await _trackersCollection.doc(trackerId).update({
      'completedTasks': FieldValue.arrayUnion([task]),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Remove completed task
  Future<void> removeCompletedTask(String trackerId, String task) async {
    await _trackersCollection.doc(trackerId).update({
      'completedTasks': FieldValue.arrayRemove([task]),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Update completed Pomodoro sessions
  Future<void> updateCompletedPomodoroSessions(
    String trackerId,
    int sessions,
  ) async {
    if (sessions < 0) {
      throw Exception('Completed sessions cannot be negative');
    }

    await _trackersCollection.doc(trackerId).update({
      'completedPomodoroSessions': sessions,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Update events stats
  Future<void> updateEventsStats(
    String trackerId,
    int completed,
    int total,
  ) async {
    if (completed < 0 || total < 0 || completed > total) {
      throw Exception('Invalid event stats');
    }

    await _trackersCollection.doc(trackerId).update({
      'completedEvents': completed,
      'totalEvents': total,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
