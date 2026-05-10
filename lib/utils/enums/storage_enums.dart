/// Storage keys enumeration
enum StorageEnum {
  user('user'),
  habits('habits'),
  completions('completions'),
  journalEntries('journalEntries'),
  settings('settings'),
  theme('theme'),
  locale('locale'),
  backupEnabled('backupEnabled'),
  lastSyncTime('lastSyncTime'),
  streakFreeze('streakFreeze');

  final String key;
  const StorageEnum(this.key);
}

/// Habit schedule types
enum HabitSchedule {
  daily('daily'),
  weekdays('weekdays'),
  weekends('weekends'),
  custom('custom');

  final String value;
  const HabitSchedule(this.value);
}

/// Week days
enum WeekDay {
  monday(1, 'Monday'),
  tuesday(2, 'Tuesday'),
  wednesday(3, 'Wednesday'),
  thursday(4, 'Thursday'),
  friday(5, 'Friday'),
  saturday(6, 'Saturday'),
  sunday(7, 'Sunday');

  final int value;
  final String name;
  const WeekDay(this.value, this.name);
}

/// Theme mode
enum ThemeMode { light, dark, system }

/// View mode for home screen
enum HomeViewMode { streak, list }

/// Filter type for habits
enum HabitFilter { all, due, completed, archived }
