/// Application constants
class AppConstant {
  // Version
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // API Configuration
  static const String baseUrl = 'https://api.tickoff.app';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Notification Configuration
  static const String notificationChannelId = 'habit_reminders';
  static const String notificationChannelName = 'Habit Reminders';
  static const String notificationChannelDesc =
      'Notifications for habit reminders';

  // Streak Configuration
  static const int streakFreezeLimit = 1; // Per week
  static const List<int> streakMilestones = [7, 21, 30, 60, 90, 100, 200, 365];

  // UI Configuration
  static const int maxHabitNameLength = 50;
  static const int maxJournalNoteLength = 500;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // Database Configuration
  static const String dbName = 'tickoff.db';
  static const int dbVersion = 1;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 300);

  // Grace Period for Habits (in hours before midnight)
  static const int gracePeriodHours = 0; // No grace period by default

  // Backup Configuration
  static const Duration backupInterval = Duration(hours: 6);
  static const int maxBackupRetries = 5;

  // Empty State Configuration
  static const String emptyHabitsMessage =
      'No habits yet. Create your first habit!';
  static const String emptyJournalMessage =
      'No journal entries. Start tracking to add entries!';
}
