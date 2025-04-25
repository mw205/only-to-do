import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/daily_tracker_model.dart';

class PerformanceChart extends StatelessWidget {
  static const Color activeColor = Colors.green; // Define activeColor
  final List<DailyTrackerModel> trackers;
  final String title;
  final String subtitle;
  final Color lineColor;
  final Color gradientColor;
  final double Function(DailyTrackerModel) valueExtractor;
  final String Function(double) tooltipFormatter;
  final double minY;
  final double maxY;

  const PerformanceChart({
    super.key,
    required this.trackers,
    required this.title,
    required this.subtitle,
    required this.lineColor,
    required this.gradientColor,
    required this.valueExtractor,
    required this.tooltipFormatter,
    this.minY = 0,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    // Sort trackers by date
    final sortedTrackers = List<DailyTrackerModel>.from(trackers)
      ..sort((a, b) => a.date.compareTo(b.date));

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (trackers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lineColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tooltipFormatter(valueExtractor(trackers.last)),
                    style: TextStyle(
                      color: lineColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                trackers.isEmpty
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
                                  days:
                                      today.weekday -
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
                                orElse:
                                    () => DailyTrackerModel(
                                      id: '',
                                      userId: '',
                                      date: cellDate,
                                      createdAt: cellDate,
                                      updatedAt: cellDate,
                                    ),
                              );

                              // Determine cell color based on tracker data
                              final isToday =
                                  cellDate.year == today.year &&
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
                                  hasRecord && valueExtractor(tracker) > 0;

                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isFutureDate
                                          ? Colors.grey[200]
                                          : isActive
                                          ? activeColor
                                          : hasRecord
                                          ? Colors.grey[300]
                                          : Colors.grey[200],
                                  border:
                                      isToday
                                          ? Border.all(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child:
                                    isActive
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
          const SizedBox(height: 16),
          Expanded(
            child:
                trackers.length < 2
                    ? Center(
                      child: Text(
                        'Not enough data to display chart',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                    : LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                final trackerIndex = spot.x.toInt();
                                if (trackerIndex >= 0 &&
                                    trackerIndex < sortedTrackers.length) {
                                  final tracker = sortedTrackers[trackerIndex];
                                  return LineTooltipItem(
                                    '${DateFormat('MMM d').format(tracker.date)}\n',
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: tooltipFormatter(spot.y),
                                        style: TextStyle(
                                          color: lineColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return null;
                              }).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300],
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < sortedTrackers.length) {
                                  final date =
                                      sortedTrackers[value.toInt()].date;
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      DateFormat('d').format(date),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value == minY ||
                                    value == maxY ||
                                    value == maxY / 2) {
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: sortedTrackers.length.toDouble() - 1,
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              sortedTrackers.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                valueExtractor(sortedTrackers[index]),
                              ),
                            ),
                            isCurved: true,
                            color: lineColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: gradientColor.withValues(alpha: .2),
                              gradient: LinearGradient(
                                colors: [
                                  gradientColor.withValues(alpha: .4),
                                  gradientColor.withValues(alpha: .0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
