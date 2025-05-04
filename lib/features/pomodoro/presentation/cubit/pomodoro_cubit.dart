// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../yourevent/services/notification_service.dart';
import 'pomodoro_state.dart';

class PomodoroCubit extends Cubit<PomodoroState> {
  PomodoroCubit() : super(PomodoroState.initial()) {
    _loadSettings();
  }

  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final focusDuration = prefs.getInt('focus_duration') ?? 25;
      final shortBreakDuration = prefs.getInt('short_break_duration') ?? 5;
      final longBreakDuration = prefs.getInt('long_break_duration') ?? 15;
      final longBreakAfter = prefs.getInt('long_break_after') ?? 4;
      final targetSessions = prefs.getInt('target_sessions') ?? 4;

      emit(
        state.copyWith(
          focusDuration: focusDuration,
          shortBreakDuration: shortBreakDuration,
          longBreakDuration: longBreakDuration,
          longBreakAfter: longBreakAfter,
          targetSessions: targetSessions,
          remainingSeconds: focusDuration * 60,
        ),
      );
    } catch (e) {
      // Default values are already set in the initial state
      print('Error loading Pomodoro settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings({
    required int focusDuration,
    required int shortBreakDuration,
    required int longBreakDuration,
    required int longBreakAfter,
    required int targetSessions,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('focus_duration', focusDuration);
      await prefs.setInt('short_break_duration', shortBreakDuration);
      await prefs.setInt('long_break_duration', longBreakDuration);
      await prefs.setInt('long_break_after', longBreakAfter);
      await prefs.setInt('target_sessions', targetSessions);

      emit(
        state.copyWith(
          focusDuration: focusDuration,
          shortBreakDuration: shortBreakDuration,
          longBreakDuration: longBreakDuration,
          longBreakAfter: longBreakAfter,
          targetSessions: targetSessions,
          remainingSeconds: focusDuration * 60,
          status: PomodoroStatus.initial,
        ),
      );
    } catch (e) {
      print('Error saving Pomodoro settings: $e');
    }
  }

  // Start the timer
  void start() {
    if (state.status == PomodoroStatus.running) return;

    emit(state.copyWith(status: PomodoroStatus.running));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      } else {
        _timer?.cancel();
        _handleTimeUp();
      }
    });
  }

  // Pause the timer
  void pause() {
    if (state.status != PomodoroStatus.running) return;

    _timer?.cancel();
    emit(state.copyWith(status: PomodoroStatus.paused));
  }

  // Reset the timer
  void reset() {
    _timer?.cancel();

    final newRemainingSeconds =
        state.isBreak ? _getBreakDuration() * 60 : state.focusDuration * 60;

    emit(
      state.copyWith(
        status: PomodoroStatus.initial,
        remainingSeconds: newRemainingSeconds,
      ),
    );
  }

  // Handle timer completion
  void _handleTimeUp() async {
    if (state.isBreak) {
      // Break time is over, start a new focus session
      emit(
        state.copyWith(
          status: PomodoroStatus.completed,
          isBreak: false,
          remainingSeconds: state.focusDuration * 60,
        ),
      );

      // Show notification
      await _notificationService.showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Break Completed',
        body: 'Time to focus again!',
      );
    } else {
      // Focus session is over
      final newCompletedSessions = state.completedSessions + 1;
      final isLongBreak = newCompletedSessions % state.longBreakAfter == 0;
      final breakDuration =
          isLongBreak ? state.longBreakDuration : state.shortBreakDuration;

      emit(
        state.copyWith(
          status: PomodoroStatus.completed,
          completedSessions: newCompletedSessions,
          isBreak: true,
          remainingSeconds: breakDuration * 60,
        ),
      );

      // Show notification
      await _notificationService.showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Focus Session Completed',
        body:
            isLongBreak ? 'Time for a long break!' : 'Time for a short break!',
      );
    }
  }

  // Skip to the next session
  void skipToNext() {
    _timer?.cancel();

    if (state.isBreak) {
      // Skip break, start new focus session
      emit(
        state.copyWith(
          status: PomodoroStatus.initial,
          isBreak: false,
          remainingSeconds: state.focusDuration * 60,
        ),
      );
    } else {
      // Skip focus, start break
      final newCompletedSessions = state.completedSessions + 1;
      final isLongBreak = newCompletedSessions % state.longBreakAfter == 0;
      final breakDuration =
          isLongBreak ? state.longBreakDuration : state.shortBreakDuration;

      emit(
        state.copyWith(
          status: PomodoroStatus.initial,
          completedSessions: newCompletedSessions,
          isBreak: true,
          remainingSeconds: breakDuration * 60,
        ),
      );
    }
  }

  // Get current break duration
  int _getBreakDuration() {
    final isLongBreak = (state.completedSessions % state.longBreakAfter == 0) &&
        state.completedSessions > 0;

    return isLongBreak ? state.longBreakDuration : state.shortBreakDuration;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
