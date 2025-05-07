import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';
import '../../widgets/event_card.dart';
import 'add_edit_event_page.dart';
import 'event_details_page.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});
  static const String id = 'events_list_page';

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showUpcomingOnly = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Load events
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      setState(() {
        _showUpcomingOnly = true;
      });
      _loadEvents();
    } else {
      setState(() {
        _showUpcomingOnly = false;
      });
      _loadEvents();
    }
  }

  void _loadEvents() {
    if (_showUpcomingOnly) {
      context.read<EventsCubit>().loadUpcomingEvents();
    } else {
      context.read<EventsCubit>().loadEvents();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(16),
          Material(
            child: TabBar(
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicatorColor: ColorName.purple,
              tabs: const [Tab(text: 'Upcoming'), Tab(text: 'All Events')],
            ),
          ),
          Expanded(
            child: BlocConsumer<EventsCubit, EventsState>(
              listener: (context, state) {
                if (state.status == EventsStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == EventsStatus.initial) {
                  return const Center(child: Text('No events yet'));
                }

                if (state.status == EventsStatus.loading &&
                    state.events.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const Gap(16),
                        Text(
                          _showUpcomingOnly
                              ? 'No upcoming events'
                              : 'No events found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const Gap(24),
                        ElevatedButton(
                          onPressed: () => _navigateToAddEvent(context),
                          child: const Text('Add New Event'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadEvents(),
                  child: ListView.builder(
                    itemCount: state.events.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      return EventCard(
                        event: event,
                        onTap: () => _navigateToEventDetails(context, event),
                        onDelete: () => _showDeleteConfirmation(context, event),
                        onCompleted: (isCompleted) {
                          context.read<EventsCubit>().markEventAsCompleted(
                                event.id,
                                isCompleted,
                              );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)),
    );
  }

  void _navigateToAddEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditEventPage()),
    );

    if (result == true) {
      _loadEvents();
    }
  }

  void _showDeleteConfirmation(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EventsCubit>().deleteEvent(event.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
