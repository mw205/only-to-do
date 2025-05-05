import '../../../features/yourevent/services/storage_service.dart';
import '../models/daily_tracker_model.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';

class LocalDataSource {
  final StorageService _storageService = StorageService();

  // Initialize local storage
  Future<void> init() async {
    await _storageService.init();
  }

  // User methods

  // Save current user
  Future<void> saveCurrentUser(UserModel user) async {
    await _storageService.saveUserId(user.id);
    await _storageService.saveUserEmail(user.email);
    await _storageService.saveUserName(user.name);
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final userId = await _storageService.getUserId();
    final email = await _storageService.getUserEmail();
    final name = await _storageService.getUserName();
    final isPremuim = await _storageService.checkIfUserIsPremuim();
    if (userId == null || email == null || name == null || isPremuim == null) {
      return null;
    }

    return UserModel(
      id: userId,
      email: email,
      name: name,
      createdAt: DateTime.now(), // Not accurate but just for local use
      updatedAt: DateTime.now(),
      isPremuim: isPremuim,
    );
  }

  // Clear current user
  Future<void> clearCurrentUser() async {
    await _storageService.clearUserData();
  }

  // Event methods

  // Cache events
  Future<void> cacheEvents(List<EventModel> events) async {
    final eventMaps = events.map((event) => _eventModelToMap(event)).toList();
    await _storageService.cacheEvents(eventMaps);
  }

  // Get cached events
  List<EventModel> getCachedEvents() {
    final eventMaps = _storageService.getCachedEvents();
    return eventMaps.map((map) => _mapToEventModel(map)).toList();
  }

  // Cache single event
  Future<void> cacheEvent(EventModel event) async {
    await _storageService.cacheEvent(event.id, _eventModelToMap(event));
  }

  // Get cached event by ID
  EventModel? getCachedEvent(String eventId) {
    final eventMap = _storageService.getCachedEvent(eventId);
    if (eventMap == null) return null;
    return _mapToEventModel(eventMap);
  }

  // Remove cached event
  Future<void> removeCachedEvent(String eventId) async {
    await _storageService.removeCachedEvent(eventId);
  }

  // Clear all cached events
  Future<void> clearCachedEvents() async {
    await _storageService.clearCachedEvents();
  }

  // Tracker methods

  // Cache tracker
  Future<void> cacheTracker(DailyTrackerModel tracker) async {
    final dateKey = _formatDateKey(tracker.date);
    await _storageService.cacheTracker(dateKey, _trackerModelToMap(tracker));
  }

  // Get cached tracker by date
  DailyTrackerModel? getCachedTracker(DateTime date) {
    final dateKey = _formatDateKey(date);
    final trackerMap = _storageService.getCachedTracker(dateKey);
    if (trackerMap == null) return null;
    return _mapToTrackerModel(trackerMap);
  }

  // Cache weekly trackers
  Future<void> cacheWeeklyTrackers(List<DailyTrackerModel> trackers) async {
    final trackerMaps =
        trackers.map((tracker) => _trackerModelToMap(tracker)).toList();
    await _storageService.cacheWeeklyTrackers(trackerMaps);
  }

  // Get cached weekly trackers
  List<DailyTrackerModel> getCachedWeeklyTrackers() {
    final trackerMaps = _storageService.getCachedWeeklyTrackers();
    return trackerMaps.map((map) => _mapToTrackerModel(map)).toList();
  }

  // Cache monthly trackers
  Future<void> cacheMonthlyTrackers(List<DailyTrackerModel> trackers) async {
    final trackerMaps =
        trackers.map((tracker) => _trackerModelToMap(tracker)).toList();
    await _storageService.cacheMonthlyTrackers(trackerMaps);
  }

  // Get cached monthly trackers
  List<DailyTrackerModel> getCachedMonthlyTrackers() {
    final trackerMaps = _storageService.getCachedMonthlyTrackers();
    return trackerMaps.map((map) => _mapToTrackerModel(map)).toList();
  }

  // Clear all cached trackers
  Future<void> clearCachedTrackers() async {
    await _storageService.clearCachedTrackers();
  }

  // Settings methods

  // Save FCM token
  Future<void> saveFcmToken(String token) async {
    await _storageService.saveFcmToken(token);
  }

  // Get FCM token
  String? getFcmToken() {
    return _storageService.getFcmToken();
  }

  // Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    await _storageService.saveThemeMode(themeMode);
  }

  // Get theme mode
  String getThemeMode() {
    return _storageService.getThemeMode();
  }

  // Save notification settings
  Future<void> saveNotificationSettings({
    required bool enableEventReminders,
    required bool enablePomodoroReminders,
    required bool enableDailyReminders,
  }) async {
    await _storageService.saveNotificationSettings(
      enableEventReminders: enableEventReminders,
      enablePomodoroReminders: enablePomodoroReminders,
      enableDailyReminders: enableDailyReminders,
    );
  }

  // Get notification settings
  Map<String, bool> getNotificationSettings() {
    return _storageService.getNotificationSettings();
  }

  // Clear all settings
  Future<void> clearAllSettings() async {
    await _storageService.clearAppSettings();
  }

  // Helper methods

  // Format date as key for storage
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Convert EventModel to Map
  Map<String, dynamic> _eventModelToMap(EventModel event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'eventDate': event.eventDate.millisecondsSinceEpoch,
      'reminderTimes':
          event.reminderTimes.map((dt) => dt.millisecondsSinceEpoch).toList(),
      'userId': event.userId,
      'isCompleted': event.isCompleted,
      'color': event.color,
      'icon': event.icon,
      'createdAt': event.createdAt.millisecondsSinceEpoch,
      'updatedAt': event.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Map to EventModel
  EventModel _mapToEventModel(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      reminderTimes: (map['reminderTimes'] as List)
          .map((stamp) => DateTime.fromMillisecondsSinceEpoch(stamp))
          .toList(),
      userId: map['userId'],
      isCompleted: map['isCompleted'],
      color: map['color'],
      icon: map['icon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  // Convert DailyTrackerModel to Map
  Map<String, dynamic> _trackerModelToMap(DailyTrackerModel tracker) {
    return {
      'id': tracker.id,
      'userId': tracker.userId,
      'date': tracker.date.millisecondsSinceEpoch,
      'completedEvents': tracker.completedEvents,
      'totalEvents': tracker.totalEvents,
      'completedPomodoroSessions': tracker.completedPomodoroSessions,
      'sleepHours': tracker.sleepHours,
      'dietTracked': tracker.dietTracked,
      'waterIntake': tracker.waterIntake,
      'steps': tracker.steps,
      'completedTasks': tracker.completedTasks,
      'createdAt': tracker.createdAt.millisecondsSinceEpoch,
      'updatedAt': tracker.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Map to DailyTrackerModel
  DailyTrackerModel _mapToTrackerModel(Map<String, dynamic> map) {
    return DailyTrackerModel(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      completedEvents: map['completedEvents'],
      totalEvents: map['totalEvents'],
      completedPomodoroSessions: map['completedPomodoroSessions'],
      sleepHours: map['sleepHours'],
      dietTracked: map['dietTracked'],
      waterIntake: map['waterIntake'],
      steps: map['steps'],
      completedTasks: List<String>.from(map['completedTasks']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
