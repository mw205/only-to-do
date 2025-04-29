import '../../data/models/daily_tracker_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../entities/daily_tracker.dart';
import 'dashboard_usecases.dart';

class DashboardUseCasesImpl implements DashboardUseCases {
  final DashboardRepository _dashboardRepository;

  DashboardUseCasesImpl(this._dashboardRepository);

  // Helper method to convert DailyTrackerModel to DailyTracker entity
  DailyTracker _mapModelToEntity(DailyTrackerModel model) {
    return DailyTracker(
      id: model.id,
      userId: model.userId,
      date: model.date,
      completedEvents: model.completedEvents,
      totalEvents: model.totalEvents,
      completedPomodoroSessions: model.completedPomodoroSessions,
      sleepHours: model.sleepHours,
      dietTracked: model.dietTracked,
      waterIntake: model.waterIntake,
      steps: model.steps,
      completedTasks: model.completedTasks,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // Helper method to convert DailyTracker entity to DailyTrackerModel
  DailyTrackerModel mapEntityToModel(DailyTracker entity) {
    return DailyTrackerModel(
      id: entity.id,
      userId: entity.userId,
      date: entity.date,
      completedEvents: entity.completedEvents,
      totalEvents: entity.totalEvents,
      completedPomodoroSessions: entity.completedPomodoroSessions,
      sleepHours: entity.sleepHours,
      dietTracked: entity.dietTracked,
      waterIntake: entity.waterIntake,
      steps: entity.steps,
      completedTasks: entity.completedTasks,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<DailyTracker?> getTodayTracker() async {
    final model = await _dashboardRepository.getTodayTracker();
    if (model == null) return null;
    return _mapModelToEntity(model);
  }

  @override
  Future<List<DailyTracker>> getWeekTrackers() async {
    final models = await _dashboardRepository.getWeekTrackers();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<DailyTracker>> getMonthTrackers() async {
    final models = await _dashboardRepository.getMonthTrackers();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<DailyTracker> createDailyTracker() async {
    final model = await _dashboardRepository.createDailyTracker();
    return _mapModelToEntity(model);
  }

  @override
  Future<void> updateSleepHours(String trackerId, int hours) async {
    await _dashboardRepository.updateSleepHours(trackerId, hours);
  }

  @override
  Future<void> updateWaterIntake(String trackerId, int milliliters) async {
    await _dashboardRepository.updateWaterIntake(trackerId, milliliters);
  }

  @override
  Future<void> updateSteps(String trackerId, int steps) async {
    await _dashboardRepository.updateSteps(trackerId, steps);
  }

  @override
  Future<void> toggleDietTracked(String trackerId, bool tracked) async {
    await _dashboardRepository.toggleDietTracked(trackerId, tracked);
  }

  @override
  Future<void> addCompletedTask(String trackerId, String task) async {
    await _dashboardRepository.addCompletedTask(trackerId, task);
  }

  @override
  Future<void> removeCompletedTask(String trackerId, String task) async {
    await _dashboardRepository.removeCompletedTask(trackerId, task);
  }

  @override
  Future<void> updateCompletedPomodoroSessions(
    String trackerId,
    int sessions,
  ) async {
    await _dashboardRepository.updateCompletedPomodoroSessions(
      trackerId,
      sessions,
    );
  }

  @override
  Future<void> updateEventsStats(
    String trackerId,
    int completed,
    int total,
  ) async {
    await _dashboardRepository.updateEventsStats(trackerId, completed, total);
  }
}
