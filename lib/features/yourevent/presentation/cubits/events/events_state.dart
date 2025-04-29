import 'package:equatable/equatable.dart';
import '../../../data/models/event_model.dart';

enum EventsStatus { initial, loading, success, failure }

class EventsState extends Equatable {
  final List<EventModel> events;
  final EventsStatus status;
  final String? errorMessage;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const EventsState({
    this.events = const [],
    this.status = EventsStatus.initial,
    this.errorMessage,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  // Initial state
  factory EventsState.initial() => const EventsState();

  // State with loading status
  EventsState copyWithLoading() {
    return copyWith(status: EventsStatus.loading);
  }

  // State with events loaded successfully
  EventsState copyWithSuccess(List<EventModel> events) {
    return copyWith(
      events: events,
      status: EventsStatus.success,
      errorMessage: null,
    );
  }

  // State with error
  EventsState copyWithFailure(String errorMessage) {
    return copyWith(status: EventsStatus.failure, errorMessage: errorMessage);
  }

  // Copy with specified attributes changed
  EventsState copyWith({
    List<EventModel>? events,
    EventsStatus? status,
    String? errorMessage,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return EventsState(
      events: events ?? this.events,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
        events,
        status,
        errorMessage,
        isCreating,
        isUpdating,
        isDeleting,
      ];
}
