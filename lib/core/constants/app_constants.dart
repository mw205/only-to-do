class AppConstants {
  // Firebase collections
  static const String usersCollection = 'users';
  static const String eventsCollection = 'events';
  static const String trackersCollection = 'daily_trackers';

  // Shared preferences keys
  static const String isDarkModeKey = 'is_dark_mode';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String focusDurationKey = 'focus_duration';
  static const String shortBreakDurationKey = 'short_break_duration';
  static const String longBreakDurationKey = 'long_break_duration';
  static const String longBreakAfterKey = 'long_break_after';
  static const String targetSessionsKey = 'target_sessions';

  // Default values
  static const int defaultFocusDuration = 25;
  static const int defaultShortBreakDuration = 5;
  static const int defaultLongBreakDuration = 15;
  static const int defaultLongBreakAfter = 4;
  static const int defaultTargetSessions = 4;
}
