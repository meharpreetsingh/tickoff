/// Application strings and localization constants
class AppStrings {
  // App Name
  static const String appName = 'TickOff';
  static const String appTagline = 'Build habits, track streaks';

  // Bottom Navigation
  static const String navHome = 'Home';
  static const String navTimeline = 'Timeline';
  static const String navAnalytics = 'Analytics';
  static const String navSettings = 'Settings';

  // Home Screen
  static const String todayLabel = 'Today';
  static const String allHabitsLabel = 'All Habits';
  static const String dueHabitsLabel = 'Due Today';
  static const String completedLabel = 'Completed';
  static const String addHabit = 'Add Habit';
  static const String streak = 'Streak';
  static const String bestStreak = 'Best Streak';
  static const String currentStreak = 'Current Streak';

  // Habit Form
  static const String habitName = 'Habit Name';
  static const String selectIcon = 'Select Icon';
  static const String selectColor = 'Select Color';
  static const String selectCategory = 'Select Category';
  static const String selectSchedule = 'Schedule';
  static const String reminderTime = 'Reminder Time';
  static const String enableReminder = 'Enable Reminder';
  static const String notes = 'Notes (optional)';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String archive = 'Archive';
  static const String edit = 'Edit';

  // Schedule Options
  static const String scheduleDaily = 'Daily';
  static const String scheduleWeekdays = 'Weekdays';
  static const String scheduleWeekends = 'Weekends';
  static const String scheduleCustom = 'Custom';
  static const String scheduleXTimesPerWeek = 'X times per week';

  // Journal
  static const String journalEntry = 'Journal Entry';
  static const String addNote = 'Add a note...';
  static const String addPhoto = 'Add Photo';
  static const String takePhoto = 'Take Photo';
  static const String choosePhoto = 'Choose from Gallery';
  static const String noPhoto = 'No photo';
  static const String journalEntries = 'Journal Entries';

  // Timeline
  static const String timelineEmpty = 'No journal entries yet';
  static const String filterByDate = 'Filter by date';

  // Analytics
  static const String analyticsTitle = 'Analytics';
  static const String weeklyCompletion = 'Weekly Completion';
  static const String monthlyCompletion = 'Monthly Completion';
  static const String bestHabit = 'Best Habit';
  static const String totalCompleted = 'Total Completed';
  static const String completionRate = 'Completion Rate';
  static const String yearInPixels = 'Year in Pixels';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String general = 'General';
  static const String theme = 'Theme';
  static const String lightMode = 'Light Mode';
  static const String darkMode = 'Dark Mode';
  static const String systemMode = 'System';
  static const String accentColor = 'Accent Color';
  static const String weekStartDay = 'Week Starts On';
  static const String soundEnabled = 'Sound Effects';
  static const String hapticEnabled = 'Haptic Feedback';
  static const String data = 'Data';
  static const String cloudBackup = 'Cloud Backup';
  static const String exportData = 'Export Data';
  static const String importData = 'Import Data';
  static const String deleteAllData = 'Delete All Data';
  static const String about = 'About';
  static const String privacyPolicy = 'Privacy Policy';
  static const String rateApp = 'Rate App';
  static const String feedback = 'Send Feedback';
  static const String version = 'Version';

  // Dialogs & Messages
  static const String confirmDelete =
      'Are you sure you want to delete this habit?';
  static const String confirmArchive = 'Archive this habit?';
  static const String archiveInstead = 'Archive instead?';
  static const String deleteAllDataConfirm =
      'This will permanently delete all data. This action cannot be undone.';
  static const String confirmRestore = 'Restore backup?';
  static const String markAsComplete = 'Mark as complete?';
  static const String undoCompletion = 'Undo completion?';
  static const String errorOccurred = 'An error occurred';
  static const String tryAgain = 'Try Again';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String close = 'Close';
  static const String back = 'Back';

  // Streak Messages
  static const String streakMilestone = 'Milestone Reached!';
  static const String freezeUsed = 'Freeze Used';
  static const String noStreakFreeze = 'No freezes available';
  static const String dayStreak = 'day streak';

  // Empty States
  static const String noHabits = 'No habits yet';
  static const String noHabitsDesc = 'Create your first habit to get started';
  static const String noJournalEntries = 'No journal entries';
  static const String noAnalytics = 'Complete habits to see analytics';

  // Errors
  static const String errorNetwork = 'Network error. Please try again.';
  static const String errorServer = 'Server error. Please try again.';
  static const String errorUnknown = 'An unexpected error occurred';
  static const String errorValidation = 'Please check your input';
  static const String errorInvalidHabitName = 'Habit name cannot be empty';
  static const String errorInvalidEmail = 'Invalid email address';
  static const String errorInvalidPassword =
      'Password must be at least 6 characters';
  static const String errorPermissionDenied = 'Permission denied';

  // Success Messages
  static const String habitCreated = 'Habit created successfully';
  static const String habitUpdated = 'Habit updated successfully';
  static const String habitDeleted = 'Habit deleted successfully';
  static const String habitArchived = 'Habit archived successfully';
  static const String habitRestored = 'Habit restored successfully';
  static const String habitCompleted = 'Great job! Keep it up!';
  static const String dataSaved = 'Data saved successfully';
  static const String backupComplete = 'Backup completed successfully';
  static const String dataExported = 'Data exported successfully';

  // Onboarding
  static const String onboardingTitle = 'Welcome to TickOff';
  static const String onboardingDesc1 =
      'Build habits that stick with visual streaks';
  static const String onboardingDesc2 =
      'Track daily progress with a single tap';
  static const String onboardingDesc3 = 'Journal your journey along the way';
  static const String getStarted = 'Get Started';
  static const String skip = 'Skip';

  // Auth
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String noAccount = 'Don\'t have an account? ';
  static const String haveAccount = 'Already have an account? ';
  static const String createAccount = 'Create Account';
  static const String resetPasswordSent =
      'Password reset link sent to your email';
}
