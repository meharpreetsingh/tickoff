/// API endpoints
class ApiEndpoints {
  // Habits
  static const String habits = '/habits';
  static const String habitDetail = '/habits/:id';
  static const String createHabit = '/habits';
  static const String updateHabit = '/habits/:id';
  static const String deleteHabit = '/habits/:id';
  static const String archiveHabit = '/habits/:id/archive';
  static const String restoreHabit = '/habits/:id/restore';

  // Completions
  static const String completions = '/completions';
  static const String completeHabit = '/habits/:id/complete';
  static const String undoCompletion = '/habits/:id/undo';
  static const String getCompletions = '/habits/:id/completions';

  // Journal Entries
  static const String journalEntries = '/journal-entries';
  static const String journalEntry = '/journal-entries/:id';
  static const String createEntry = '/journal-entries';
  static const String updateEntry = '/journal-entries/:id';
  static const String deleteEntry = '/journal-entries/:id';
  static const String getHabitJournal = '/habits/:id/journal';

  // Categories
  static const String categories = '/categories';
  static const String categoryDetail = '/categories/:id';
  static const String createCategory = '/categories';
  static const String updateCategory = '/categories/:id';
  static const String deleteCategory = '/categories/:id';

  // Analytics
  static const String analytics = '/analytics';
  static const String habitAnalytics = '/habits/:id/analytics';
  static const String yearInPixels = '/habits/:id/year-in-pixels';

  // Backup & Sync
  static const String backup = '/backup';
  static const String restore = '/backup/restore';
  static const String sync = '/sync';

  // Auth
  static const String signIn = '/auth/signin';
  static const String signUp = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String resetPassword = '/auth/reset-password';

  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String deleteAccount = '/user/account';
}
