import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../entities/pomodoro_settings.dart';
import '../../services/firebase_service.dart';
import 'pomodoro_usecases.dart';

class PomodoroUseCasesImpl implements PomodoroUseCases {
  final DashboardRepository _dashboardRepository;
  final FirebaseService _firebaseService;

  PomodoroUseCasesImpl(this._dashboardRepository, this._firebaseService);

  @override
  Future<PomodoroSettings> loadSettings() async {
    try {
      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final prefs = await SharedPreferences.getInstance();
      final focusDuration = prefs.getInt('focus_duration') ?? 25;
      final shortBreakDuration = prefs.getInt('short_break_duration') ?? 5;
      final longBreakDuration = prefs.getInt('long_break_duration') ?? 15;
      final longBreakAfter = prefs.getInt('long_break_after') ?? 4;
      final targetSessions = prefs.getInt('target_sessions') ?? 8;
      final autoStartBreaks = prefs.getBool('auto_start_breaks') ?? true;
      final autoStartPomodoros = prefs.getBool('auto_start_pomodoros') ?? false;

      return PomodoroSettings(
        focusDuration: focusDuration,
        shortBreakDuration: shortBreakDuration,
        longBreakDuration: longBreakDuration,
        longBreakAfter: longBreakAfter,
        targetSessions: targetSessions,
        autoStartBreaks: autoStartBreaks,
        autoStartPomodoros: autoStartPomodoros,
        userId: userId,
      );
    } catch (e) {
      // Return default settings if error
      final userId = _firebaseService.currentUserId ?? 'unknown';
      return PomodoroSettings(userId: userId);
    }
  }

  @override
  Future<void> saveSettings(PomodoroSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('focus_duration', settings.focusDuration);
      await prefs.setInt('short_break_duration', settings.shortBreakDuration);
      await prefs.setInt('long_break_duration', settings.longBreakDuration);
      await prefs.setInt('long_break_after', settings.longBreakAfter);
      await prefs.setInt('target_sessions', settings.targetSessions);
      await prefs.setBool('auto_start_breaks', settings.autoStartBreaks);
      await prefs.setBool('auto_start_pomodoros', settings.autoStartPomodoros);
    } catch (e) {
      throw Exception('Failed to save Pomodoro settings: $e');
    }
  }

  @override
  Future<void> updateCompletedSessions(int count) async {
    try {
      final tracker = await _dashboardRepository.getTodayTracker();
      if (tracker != null) {
        await _dashboardRepository.updateCompletedPomodoroSessions(
          tracker.id,
          count,
        );
      }
    } catch (e) {
      throw Exception('Failed to update completed sessions: $e');
    }
  }

  @override
  Future<int> getDailySessionTarget() async {
    try {
      final settings = await loadSettings();
      return settings.targetSessions;
    } catch (e) {
      return 8; // Default value
    }
  }

  @override
  Future<int> getTodayCompletedSessions() async {
    try {
      final tracker = await _dashboardRepository.getTodayTracker();
      return tracker?.completedPomodoroSessions ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
