import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../../../../core/data/repositories/event_repository.dart';
import '../../../services/notification_service.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventRepository _eventRepository;
  final NotificationService _notificationService = NotificationService();

  // Stream subscription for events
  StreamSubscription? _eventsSubscription;

  EventsCubit({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(EventsState.initial());

  // Load all events for current user
  void loadEvents() {
    emit(state.copyWithLoading());

    _eventsSubscription?.cancel();
    _eventsSubscription = _eventRepository.getEvents().listen(
      (events) {
        emit(state.copyWithSuccess(events));
        _scheduleNotifications(events);
      },
      onError: (error) {
        emit(state.copyWithFailure(error.toString()));
      },
    );
  }

  // Load upcoming events
  void loadUpcomingEvents() {
    emit(state.copyWithLoading());

    _eventsSubscription?.cancel();
    _eventsSubscription = _eventRepository.getUpcomingEvents().listen(
      (events) {
        emit(state.copyWithSuccess(events));
        _scheduleNotifications(events);
      },
      onError: (error) {
        emit(state.copyWithFailure(error.toString()));
      },
    );
  }

  // Create new event
  Future<void> createEvent(EventModel event) async {
    try {
      emit(state.copyWith(isCreating: true));

      await _eventRepository.addEvent(event);

      emit(state.copyWith(isCreating: false));
    } catch (e) {
      emit(
        state.copyWith(
          isCreating: false,
          errorMessage: 'Failed to create event: ${e.toString()}',
        ),
      );
    }
  }

  // Update existing event
  Future<void> updateEvent(EventModel event) async {
    try {
      emit(state.copyWith(isUpdating: true));

      await _eventRepository.updateEvent(event);

      emit(state.copyWith(isUpdating: false));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update event: ${e.toString()}',
        ),
      );
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    try {
      emit(state.copyWith(isDeleting: true));

      await _eventRepository.deleteEvent(eventId);

      // Cancel notifications for this event
      await _notificationService.cancelEventNotifications(eventId);

      emit(state.copyWith(isDeleting: false));
    } catch (e) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'Failed to delete event: ${e.toString()}',
        ),
      );
    }
  }

  // Mark event as completed
  Future<void> markEventAsCompleted(String eventId, bool isCompleted) async {
    try {
      await _eventRepository.markEventAsCompleted(eventId, isCompleted);
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to update event status: ${e.toString()}',
        ),
      );
    }
  }

  // Schedule notifications for events
  void _scheduleNotifications(List<EventModel> events) async {
    // Cancel all existing notifications first
    await _notificationService.cancelAllNotifications();

    // Schedule new notifications for each event
    for (final event in events) {
      if (event.eventDate.isAfter(DateTime.now()) && !event.isCompleted) {
        // Schedule main event notification
        await _notificationService.scheduleEventNotification(
          id: event.id.hashCode,
          title: 'Event Reminder: ${event.title}',
          body: event.description,
          scheduledDate: event.eventDate,
          payload: event.id,
        );

        // Schedule reminder notifications
        for (final reminderTime in event.reminderTimes) {
          if (reminderTime.isAfter(DateTime.now())) {
            await _notificationService.scheduleEventNotification(
              id: '${event.id}_${reminderTime.millisecondsSinceEpoch}'.hashCode,
              title: 'Upcoming: ${event.title}',
              body:
                  'This event is scheduled for ${_formatReminderTime(event.eventDate, reminderTime)}',
              scheduledDate: reminderTime,
              payload: event.id,
            );
          }
        }
      }
    }
  }

  // Format reminder time as relative to event date
  String _formatReminderTime(DateTime eventDate, DateTime reminderTime) {
    final difference = eventDate.difference(reminderTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} from now';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} from now';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} from now';
    }
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}
