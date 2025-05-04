import 'package:flutter/material.dart';
import '../../../../../core/data/models/daily_tracker_model.dart';

class HabitTrackerChart extends StatelessWidget {
  final List<DailyTrackerModel> trackers;
  final String title;
  final bool Function(DailyTrackerModel) valueExtractor;
  final Color activeColor;

  const HabitTrackerChart({
    super.key,
    required this.trackers,
    required this.title,
    required this.valueExtractor,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Sort trackers by date
    final sortedTrackers = List<DailyTrackerModel>.from(trackers)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate streak
    int currentStreak = 0;
    for (int i = sortedTrackers.length - 1; i >= 0; i--) {
      if (valueExtractor(sortedTrackers[i])) {
        currentStreak++;
      } else {
        break;
      }
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: RichText(
                  text: TextSpan(
                    text: '$currentStreak',
                    style: TextStyle(
                      color: activeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: ' day streak',
                        style: TextStyle(
                          color: activeColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: trackers.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : Row(
                    children: [
                      // Weekday labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'Mon',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Tue',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Wed',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Thu',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Fri',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Sat',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Sun',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Habit grid
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: 7 * 5, // 5 weeks
                          itemBuilder: (context, index) {
                            final weekIndex = index ~/ 7; // 0-4 (weeks)
                            final dayIndex = index % 7; // 0-6 (days of week)

                            // Calculate the date for this grid cell
                            final today = DateTime.now();
                            final firstDayOfGrid = today.subtract(
                              Duration(
                                days: today.weekday -
                                    1 +
                                    (7 * 4), // Go back to Monday 4 weeks ago
                              ),
                            );
                            final cellDate = firstDayOfGrid.add(
                              Duration(days: weekIndex * 7 + dayIndex),
                            );

                            // Find tracker for this date if it exists
                            final tracker = sortedTrackers.firstWhere(
                              (t) =>
                                  t.date.year == cellDate.year &&
                                  t.date.month == cellDate.month &&
                                  t.date.day == cellDate.day,
                              orElse: () => DailyTrackerModel(
                                id: '',
                                userId: '',
                                date: cellDate,
                                createdAt: cellDate,
                                updatedAt: cellDate,
                              ),
                            );

                            // Determine cell color based on tracker data
                            final isToday = cellDate.year == today.year &&
                                cellDate.month == today.month &&
                                cellDate.day == today.day;

                            final isFutureDate = cellDate.isAfter(today);

                            final hasRecord = sortedTrackers.any(
                              (t) =>
                                  t.date.year == cellDate.year &&
                                  t.date.month == cellDate.month &&
                                  t.date.day == cellDate.day,
                            );

                            final bool isActive =
                                hasRecord && valueExtractor(tracker);

                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFutureDate
                                    ? Colors.grey[200]
                                    : isActive
                                        ? activeColor
                                        : hasRecord
                                            ? Colors.grey[300]
                                            : Colors.grey[200],
                                border: isToday
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: isActive
                                  ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
