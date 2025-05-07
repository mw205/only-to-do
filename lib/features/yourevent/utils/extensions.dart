import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Extension on DateTime
extension DateTimeExtension on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  // Get start of day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  // Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // Format as "h:mm a" (e.g., "2:30 PM")
  String get timeString => DateFormat('h:mm a').format(this);

  // Format as "MMM d" (e.g., "Jan 1")
  String get shortDateString => DateFormat('MMM d').format(this);

  // Format as "EEE, MMM d" (e.g., "Mon, Jan 1")
  String get weekdayDateString => DateFormat('EEE, MMM d').format(this);

  // Get time difference from now as a readable string
  String get timeFromNow {
    final now = DateTime.now();
    final timeDifference = difference(now);

    if (timeDifference.inDays > 365) {
      final years = (timeDifference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (timeDifference.inDays > 30) {
      final months = (timeDifference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (timeDifference.inDays > 0) {
      return '${timeDifference.inDays} ${timeDifference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (timeDifference.inHours > 0) {
      return '${timeDifference.inHours} ${timeDifference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (timeDifference.inMinutes > 0) {
      return '${timeDifference.inMinutes} ${timeDifference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}

// Extension on TimeOfDay
extension TimeOfDayExtension on TimeOfDay {
  // Format as "h:mm a" (e.g., "2:30 PM")
  String format(BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat('h:mm a').format(dateTime);
  }

  // Compare TimeOfDay objects
  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }

  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  // Convert to minutes since midnight
  int toMinutes() {
    return hour * 60 + minute;
  }

  // Create TimeOfDay from minutes since midnight
  static TimeOfDay fromMinutes(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // Add minutes to TimeOfDay
  TimeOfDay addMinutes(int minutes) {
    final totalMinutes = toMinutes() + minutes;
    return TimeOfDayExtension.fromMinutes(totalMinutes);
  }
}

// Extension on Duration
extension DurationExtension on Duration {
  // Format as "hh:mm:ss"
  String get formatted {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  // Format as "h:mm:ss" (without leading zeros for hours)
  String get formattedCompact {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  // Format for countdown display (days, hours, minutes, seconds)
  String get countdownFormatted {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final daysStr = days > 0 ? '${days}d ' : '';
    final hoursStr = hours > 0 || days > 0 ? '${hours}h ' : '';
    final minutesStr = '${minutes}m ';
    final secondsStr = '${seconds}s';

    return '$daysStr$hoursStr$minutesStr$secondsStr';
  }
}
