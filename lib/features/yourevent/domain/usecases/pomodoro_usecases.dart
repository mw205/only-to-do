import '../entities/pomodoro_settings.dart';

abstract class PomodoroUseCases {
  /// Load the saved Pomodoro settings for the current user
  Future<PomodoroSettings> loadSettings();

  /// Save Pomodoro settings
  Future<void> saveSettings(PomodoroSettings settings);

  /// Update the Pomodoro session count for today
  Future<void> updateCompletedSessions(int count);

  /// Get the daily target of Pomodoro sessions
  Future<int> getDailySessionTarget();

  /// Get the total completed Pomodoro sessions for today
  Future<int> getTodayCompletedSessions();
}
