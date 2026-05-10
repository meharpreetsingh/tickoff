/// Route paths and names for navigation
enum RouterEnum {
  root('/'),
  home('/home'),
  addHabit('/add-habit'),
  editHabit('/edit-habit/:id'),
  habitDetail('/habit-detail/:id'),
  timeline('/timeline'),
  analytics('/analytics'),
  settings('/settings'),
  onboarding('/onboarding'),
  splash('/splash'),
  journalEntry('/journal-entry/:habitId'),
  habitJournal('/habit-journal/:habitId'),
  backup('/backup'),
  about('/about');

  final String path;
  const RouterEnum(this.path);

  String get name => toString().split('.').last;
}

/// Route names
class RouteNames {
  static const String root = 'root';
  static const String home = 'home';
  static const String addHabit = 'addHabit';
  static const String editHabit = 'editHabit';
  static const String habitDetail = 'habitDetail';
  static const String timeline = 'timeline';
  static const String analytics = 'analytics';
  static const String settings = 'settings';
  static const String onboarding = 'onboarding';
  static const String splash = 'splash';
  static const String journalEntry = 'journalEntry';
  static const String habitJournal = 'habitJournal';
  static const String backup = 'backup';
  static const String about = 'about';
}
