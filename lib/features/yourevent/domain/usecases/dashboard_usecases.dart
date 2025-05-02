import '../entities/daily_tracker.dart';

abstract class DashboardUseCases {
  /// Get today's tracker for the current user
  Future<DailyTracker?> getTodayTracker();

  /// Get trackers for the past 7 days
  Future<List<DailyTracker>> getWeekTrackers();

  /// Get trackers for the past 30 days
  Future<List<DailyTracker>> getMonthTrackers();

  /// Create a new daily tracker
  Future<DailyTracker> createDailyTracker();

  /// Update sleep hours for a tracker
  Future<void> updateSleepHours(String trackerId, int hours);

  /// Update water intake for a tracker
  Future<void> updateWaterIntake(String trackerId, int milliliters);

  /// Update steps for a tracker
  Future<void> updateSteps(String trackerId, int steps);

  /// Toggle diet tracked for a tracker
  Future<void> toggleDietTracked(String trackerId, bool tracked);

  /// Add a completed task to a tracker
  Future<void> addCompletedTask(String trackerId, String task);

  /// Remove a completed task from a tracker
  Future<void> removeCompletedTask(String trackerId, String task);

  /// Update completed Pomodoro sessions for a tracker
  Future<void> updateCompletedPomodoroSessions(String trackerId, int sessions);

  /// Update events stats (completed and total) for a tracker
  Future<void> updateEventsStats(String trackerId, int completed, int total);
}
