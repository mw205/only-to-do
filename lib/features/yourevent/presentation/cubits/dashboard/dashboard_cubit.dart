import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/daily_tracker_model.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/event_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;
  final EventRepository _eventRepository;

  DashboardCubit({
    required DashboardRepository dashboardRepository,
    required EventRepository eventRepository,
  })  : _dashboardRepository = dashboardRepository,
        _eventRepository = eventRepository,
        super(DashboardState.initial());

  // Load dashboard data
  Future<void> loadDashboard() async {
    emit(state.copyWithLoading());

    try {
      // Load today's tracker
      final todayTracker = await _dashboardRepository.getTodayTracker();

      // Load period trackers based on current period
      List<DailyTrackerModel> periodTrackers = [];

      switch (state.period) {
        case DashboardPeriod.daily:
          periodTrackers = todayTracker != null ? [todayTracker] : [];
          break;
        case DashboardPeriod.weekly:
          periodTrackers = await _dashboardRepository.getWeekTrackers();
          break;
        case DashboardPeriod.monthly:
          periodTrackers = await _dashboardRepository.getMonthTrackers();
          break;
      }

      // Update events stats for today's tracker
      if (todayTracker != null) {
        _updateEventsStats(todayTracker);
      }

      emit(
        state.copyWithSuccess(
          todayTracker: todayTracker,
          periodTrackers: periodTrackers,
        ),
      );
    } catch (e) {
      emit(state.copyWithFailure('Failed to load dashboard: ${e.toString()}'));
    }
  }

  // Change dashboard period
  Future<void> changePeriod(DashboardPeriod period) async {
    if (state.period == period) return;

    emit(state.copyWith(period: period));
    loadDashboard();
  }

  // Update sleep hours
  Future<void> updateSleepHours(int hours) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.updateSleepHours(
        state.todayTracker!.id,
        hours,
      );

      final updatedTracker = state.todayTracker!.copyWith(
        sleepHours: hours,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update sleep hours: ${e.toString()}',
        ),
      );
    }
  }

  // Update water intake
  Future<void> updateWaterIntake(int milliliters) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.updateWaterIntake(
        state.todayTracker!.id,
        milliliters,
      );

      final updatedTracker = state.todayTracker!.copyWith(
        waterIntake: milliliters,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update water intake: ${e.toString()}',
        ),
      );
    }
  }

  // Update steps
  Future<void> updateSteps(int steps) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.updateSteps(state.todayTracker!.id, steps);

      final updatedTracker = state.todayTracker!.copyWith(
        steps: steps,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update steps: ${e.toString()}',
        ),
      );
    }
  }

  // Toggle diet tracked
  Future<void> toggleDietTracked(bool tracked) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.toggleDietTracked(
        state.todayTracker!.id,
        tracked,
      );

      final updatedTracker = state.todayTracker!.copyWith(
        dietTracked: tracked,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update diet tracking: ${e.toString()}',
        ),
      );
    }
  }

  // Add completed task
  Future<void> addCompletedTask(String task) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.addCompletedTask(state.todayTracker!.id, task);

      final updatedTasks = List<String>.from(state.todayTracker!.completedTasks)
        ..add(task);

      final updatedTracker = state.todayTracker!.copyWith(
        completedTasks: updatedTasks,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to add completed task: ${e.toString()}',
        ),
      );
    }
  }

  // Remove completed task
  Future<void> removeCompletedTask(String task) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.removeCompletedTask(
        state.todayTracker!.id,
        task,
      );

      final updatedTasks = List<String>.from(state.todayTracker!.completedTasks)
        ..remove(task);

      final updatedTracker = state.todayTracker!.copyWith(
        completedTasks: updatedTasks,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to remove completed task: ${e.toString()}',
        ),
      );
    }
  }

  // Update completed Pomodoro sessions
  Future<void> updateCompletedPomodoroSessions(int sessions) async {
    if (state.todayTracker == null) return;

    try {
      emit(state.copyWith(isUpdating: true));

      await _dashboardRepository.updateCompletedPomodoroSessions(
        state.todayTracker!.id,
        sessions,
      );

      final updatedTracker = state.todayTracker!.copyWith(
        completedPomodoroSessions: sessions,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(isUpdating: false, todayTracker: updatedTracker));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update Pomodoro sessions: ${e.toString()}',
        ),
      );
    }
  }

  // Update events stats
  Future<void> _updateEventsStats(DailyTrackerModel tracker) async {
    try {
      // Get all events
      final eventsStream = _eventRepository.getEvents();

      // Wait for the first emission from the stream
      final events = await eventsStream.first;

      // Calculate completed and total events for today
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final todayEvents = events.where((event) {
        final eventDate = DateTime(
          event.eventDate.year,
          event.eventDate.month,
          event.eventDate.day,
        );
        return eventDate.isAtSameMomentAs(today);
      }).toList();

      final completedEvents =
          todayEvents.where((event) => event.isCompleted).length;
      final totalEvents = todayEvents.length;

      // Update repository if values are different
      if (completedEvents != tracker.completedEvents ||
          totalEvents != tracker.totalEvents) {
        await _dashboardRepository.updateEventsStats(
          tracker.id,
          completedEvents,
          totalEvents,
        );

        final updatedTracker = tracker.copyWith(
          completedEvents: completedEvents,
          totalEvents: totalEvents,
          updatedAt: DateTime.now(),
        );

        emit(state.copyWith(todayTracker: updatedTracker));
      }
    } catch (e) {
      log('Failed to update events stats: ${e.toString()}');
    }
  }
}
