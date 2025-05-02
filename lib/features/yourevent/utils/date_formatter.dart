import 'package:intl/intl.dart';

class DateFormatter {
  // Format date as "MMM dd, yyyy" (e.g., "Jan 01, 2023")
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as "EEEE, MMMM d, yyyy" (e.g., "Monday, January 1, 2023")
  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  // Format date and time as "MMM dd, yyyy - h:mm a" (e.g., "Jan 01, 2023 - 2:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - h:mm a').format(date);
  }

  // Format date and time as "EEEE, MMMM d, yyyy - h:mm a" (e.g., "Monday, January 1, 2023 - 2:30 PM")
  static String formatLongDateTime(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy - h:mm a').format(date);
  }

  // Format time as "h:mm a" (e.g., "2:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  // Format date as relative to now (e.g., "Today", "Yesterday", "Tomorrow", or "MMM dd, yyyy")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else {
      return formatShortDate(date);
    }
  }

  // Format remaining time as countdown string (e.g., "2d 5h 30m 15s")
  static String formatCountdown(Duration duration) {
    if (duration.isNegative) {
      return 'Expired';
    }

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];

    if (days > 0) {
      parts.add('${days}d');
    }

    if (hours > 0 || days > 0) {
      parts.add('${hours}h');
    }

    if (minutes > 0 || hours > 0 || days > 0) {
      parts.add('${minutes}m');
    }

    parts.add('${seconds}s');

    return parts.join(' ');
  }

  // Format relative time (e.g., "5 minutes ago", "in 3 hours")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    final isFuture = difference.isNegative == false;
    final duration = isFuture ? difference : -difference;

    if (duration.inSeconds < 60) {
      return isFuture ? 'Just now' : 'Just now';
    } else if (duration.inMinutes < 60) {
      final minutes = duration.inMinutes;
      return isFuture
          ? 'In ${minutes == 1 ? 'a minute' : '$minutes minutes'}'
          : '${minutes == 1 ? 'A minute' : '$minutes minutes'} ago';
    } else if (duration.inHours < 24) {
      final hours = duration.inHours;
      return isFuture
          ? 'In ${hours == 1 ? 'an hour' : '$hours hours'}'
          : '${hours == 1 ? 'An hour' : '$hours hours'} ago';
    } else if (duration.inDays < 7) {
      final days = duration.inDays;
      return isFuture
          ? 'In ${days == 1 ? 'a day' : '$days days'}'
          : '${days == 1 ? 'A day' : '$days days'} ago';
    } else if (duration.inDays < 30) {
      final weeks = (duration.inDays / 7).floor();
      return isFuture
          ? 'In ${weeks == 1 ? 'a week' : '$weeks weeks'}'
          : '${weeks == 1 ? 'A week' : '$weeks weeks'} ago';
    } else if (duration.inDays < 365) {
      final months = (duration.inDays / 30).floor();
      return isFuture
          ? 'In ${months == 1 ? 'a month' : '$months months'}'
          : '${months == 1 ? 'A month' : '$months months'} ago';
    } else {
      final years = (duration.inDays / 365).floor();
      return isFuture
          ? 'In ${years == 1 ? 'a year' : '$years years'}'
          : '${years == 1 ? 'A year' : '$years years'} ago';
    }
  }
}
