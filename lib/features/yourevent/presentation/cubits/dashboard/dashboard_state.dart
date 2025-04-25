import 'package:equatable/equatable.dart';
import '../../../data/models/daily_tracker_model.dart';

enum DashboardStatus { initial, loading, success, failure }

enum DashboardPeriod { daily, weekly, monthly }

class DashboardState extends Equatable {
  final DailyTrackerModel? todayTracker;
  final List<DailyTrackerModel> periodTrackers;
  final DashboardStatus status;
  final DashboardPeriod period;
  final String? errorMessage;
  final bool isUpdating;

  const DashboardState({
    this.todayTracker,
    this.periodTrackers = const [],
    this.status = DashboardStatus.initial,
    this.period = DashboardPeriod.weekly,
    this.errorMessage,
    this.isUpdating = false,
  });

  // Initial state
  factory DashboardState.initial() => const DashboardState();

  // State with loading status
  DashboardState copyWithLoading() {
    return copyWith(status: DashboardStatus.loading);
  }

  // State with success and data
  DashboardState copyWithSuccess({
    DailyTrackerModel? todayTracker,
    List<DailyTrackerModel>? periodTrackers,
  }) {
    return copyWith(
      status: DashboardStatus.success,
      todayTracker: todayTracker,
      periodTrackers: periodTrackers,
      errorMessage: null,
    );
  }

  // State with error
  DashboardState copyWithFailure(String errorMessage) {
    return copyWith(
      status: DashboardStatus.failure,
      errorMessage: errorMessage,
    );
  }

  // Copy with specified attributes changed
  DashboardState copyWith({
    DailyTrackerModel? todayTracker,
    List<DailyTrackerModel>? periodTrackers,
    DashboardStatus? status,
    DashboardPeriod? period,
    String? errorMessage,
    bool? isUpdating,
  }) {
    return DashboardState(
      todayTracker: todayTracker ?? this.todayTracker,
      periodTrackers: periodTrackers ?? this.periodTrackers,
      status: status ?? this.status,
      period: period ?? this.period,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [
    todayTracker,
    periodTrackers,
    status,
    period,
    errorMessage,
    isUpdating,
  ];
}
