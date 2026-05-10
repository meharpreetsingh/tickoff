import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/services/injector.dart' as injector;
import '../../core/services/storage_service.dart';
import '../../data/models/category_model.dart';
import '../../data/models/completion_model.dart';
import '../../data/models/habit_model.dart';
import '../../data/models/journal_entry_model.dart';
import '../../utils/app_function.dart';
import '../../utils/enums/storage_enums.dart' as storage;

class TickOffAppState extends ChangeNotifier {
  TickOffAppState({StorageService? storageService})
      : _storageService = storageService ?? injector.storageService;

  final StorageService _storageService;

  final List<HabitModel> _habits = [];
  final List<JournalEntryModel> _journalEntries = [];
  final List<CompletionModel> _completions = [];
  final List<CategoryModel> _categories = [];

  bool _isLoaded = false;
  bool _isLoading = false;
  bool _onboardingCompleted = false;
  ThemeMode _themeMode = ThemeMode.system;
  int _weekStartDay = DateTime.monday;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _backupEnabled = false;
  String _accentColorHex = '#6366F1';
  String? _errorMessage;

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  bool get onboardingCompleted => _onboardingCompleted;
  ThemeMode get themeMode => _themeMode;
  int get weekStartDay => _weekStartDay;
  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;
  bool get backupEnabled => _backupEnabled;
  String get accentColorHex => _accentColorHex;
  String? get errorMessage => _errorMessage;

  List<HabitModel> get habits => List.unmodifiable(_habits);
  List<HabitModel> get activeHabits =>
      _sortedHabits(_habits.where((habit) => !habit.archived).toList());
  List<HabitModel> get archivedHabits =>
      _sortedHabits(_habits.where((habit) => habit.archived).toList());
  List<HabitModel> get todayHabits => _sortedHabits(
        _habits
            .where((habit) =>
                !habit.archived &&
                habit.isDueToday(
                  weekStartDay: _weekStartDay,
                ))
            .toList(),
      );
  List<HabitModel> get completedTodayHabits => _sortedHabits(
        todayHabits.where((habit) => habit.isCompletedToday()).toList(),
      );
  List<CategoryModel> get categories => List.unmodifiable(
      _categories.isEmpty ? _defaultCategories() : _categories);
  List<JournalEntryModel> get journalEntries => _journalEntries.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  List<CompletionModel> get completions => _completions.toList()
    ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

  HabitModel? habitById(String id) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index == -1) return null;
    return _habits[index];
  }

  CategoryModel? categoryById(String id) {
    final index = categories.indexWhere((category) => category.id == id);
    if (index == -1) return null;
    return categories[index];
  }

  List<JournalEntryModel> journalEntriesForHabit(String habitId) {
    return journalEntries.where((entry) => entry.habitId == habitId).toList();
  }

  List<CompletionModel> completionsForHabit(String habitId) {
    return completions.where((entry) => entry.habitId == habitId).toList();
  }

  double get completionRate {
    if (todayHabits.isEmpty) return 0;
    return completedTodayHabits.length / todayHabits.length;
  }

  int get totalCompletedCount => _completions.length;

  int get weeklyCompletionCount {
    final now = DateTime.now();
    final start =
        AppFunction.getBeginningOfWeek(now, weekStartDay: _weekStartDay);
    return _completions
        .where((completion) => !completion.completedDate.isBefore(start))
        .length;
  }

  int get monthlyCompletionCount {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return _completions
        .where((completion) => !completion.completedDate.isBefore(start))
        .length;
  }

  HabitModel? get bestHabit {
    if (_habits.isEmpty) return null;
    final sorted = activeHabits;
    if (sorted.isEmpty) return null;
    sorted.sort((a, b) => b.bestStreak.compareTo(a.bestStreak));
    return sorted.first;
  }

  HabitModel? get streakLeader {
    if (_habits.isEmpty) return null;
    final sorted = activeHabits;
    if (sorted.isEmpty) return null;
    sorted.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
    return sorted.first;
  }

  List<TimelineItem> get timelineItems {
    final items = <TimelineItem>[];
    for (final completion in _completions) {
      final habit = habitById(completion.habitId);
      if (habit != null) {
        items.add(
          TimelineItem.completion(
            completion: completion,
            habit: habit,
          ),
        );
      }
    }
    for (final entry in _journalEntries) {
      final habit = habitById(entry.habitId);
      if (habit != null) {
        items.add(
          TimelineItem.journal(
            journalEntry: entry,
            habit: habit,
          ),
        );
      }
    }
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> load() async {
    if (_isLoaded) return;
    _isLoading = true;
    notifyListeners();

    try {
      _loadSettings();
      _loadCategories();
      _loadHabits();
      _loadJournalEntries();
      _loadCompletions();

      if (_habits.isEmpty) {
        _seedDemoData();
        await _persistAll();
      }

      _isLoaded = true;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _onboardingCompleted = completed;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setWeekStartDay(int value) async {
    _weekStartDay = value;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setHapticEnabled(bool value) async {
    _hapticEnabled = value;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setBackupEnabled(bool value) async {
    _backupEnabled = value;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setAccentColor(String hexColor) async {
    _accentColorHex = hexColor;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> upsertHabit(HabitModel habit) async {
    final now = DateTime.now();
    final index = _habits.indexWhere((item) => item.id == habit.id);
    final existing = index == -1 ? null : _habits[index];

    final merged = habit.copyWith(
      createdAt: existing?.createdAt ?? habit.createdAt,
      updatedAt: now,
      currentStreak: existing?.currentStreak ?? habit.currentStreak,
      bestStreak: existing?.bestStreak ?? habit.bestStreak,
      lastCompletedAt: existing?.lastCompletedAt ?? habit.lastCompletedAt,
      totalCompletions: existing?.totalCompletions ?? habit.totalCompletions,
      journalEntryIds: existing?.journalEntryIds ?? habit.journalEntryIds,
    );

    if (index == -1) {
      _habits.add(merged);
    } else {
      _habits[index] = merged;
    }

    await _persistHabits();
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((habit) => habit.id == id);
    _journalEntries.removeWhere((entry) => entry.habitId == id);
    _completions.removeWhere((completion) => completion.habitId == id);
    await _persistAll();
    notifyListeners();
  }

  Future<void> archiveHabit(String id) async {
    final habit = habitById(id);
    if (habit == null) return;
    await upsertHabit(habit.copyWith(archived: true));
  }

  Future<void> restoreHabit(String id) async {
    final habit = habitById(id);
    if (habit == null) return;
    await upsertHabit(habit.copyWith(archived: false));
  }

  Future<void> togglePaused(String id) async {
    final habit = habitById(id);
    if (habit == null) return;
    await upsertHabit(habit.copyWith(paused: !habit.paused));
  }

  Future<void> markComplete(String habitId, {DateTime? date}) async {
    final habit = habitById(habitId);
    if (habit == null) return;

    final normalizedDate = AppFunction.getMidnightDate(date ?? DateTime.now());
    final existingIndex = _completions.indexWhere(
      (completion) =>
          completion.habitId == habitId &&
          AppFunction.getMidnightDate(completion.completedDate) ==
              normalizedDate,
    );

    if (existingIndex != -1) return;

    final completion = CompletionModel(
      id: AppFunction.generateUuid(),
      habitId: habitId,
      completedDate: normalizedDate,
      completedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    _completions.add(completion);
    await _recalculateHabitStats(habitId);
    await _persistCompletions();
    await _persistHabits();
    notifyListeners();
  }

  Future<void> undoCompletion(String habitId, {DateTime? date}) async {
    final normalizedDate = AppFunction.getMidnightDate(date ?? DateTime.now());
    _completions.removeWhere(
      (completion) =>
          completion.habitId == habitId &&
          AppFunction.getMidnightDate(completion.completedDate) ==
              normalizedDate,
    );
    await _recalculateHabitStats(habitId);
    await _persistCompletions();
    await _persistHabits();
    notifyListeners();
  }

  Future<void> addJournalEntry({
    required String habitId,
    String? note,
    String? photoPath,
  }) async {
    final now = DateTime.now();
    final entry = JournalEntryModel(
      id: AppFunction.generateUuid(),
      habitId: habitId,
      note: note,
      photoPath: photoPath,
      createdAt: now,
      updatedAt: now,
    );
    _journalEntries.add(entry);
    await _persistJournalEntries();
    notifyListeners();
  }

  Future<void> updateJournalEntry(JournalEntryModel updatedEntry) async {
    final index =
        _journalEntries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index == -1) return;
    _journalEntries[index] = updatedEntry.copyWith(updatedAt: DateTime.now());
    await _persistJournalEntries();
    notifyListeners();
  }

  Future<void> deleteJournalEntry(String id) async {
    _journalEntries.removeWhere((entry) => entry.id == id);
    await _persistJournalEntries();
    notifyListeners();
  }

  Future<String> exportBackupJson() async {
    final payload = <String, dynamic>{
      'settings': _settingsJson(),
      'habits': _habits.map((habit) => habit.toJson()).toList(),
      'journalEntries': _journalEntries.map((entry) => entry.toJson()).toList(),
      'completions':
          _completions.map((completion) => completion.toJson()).toList(),
    };
    return jsonEncode(payload);
  }

  Future<void> restoreFromBackupJson(String jsonString) async {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    _loadSettingsFromMap(Map<String, dynamic>.from(decoded['settings'] as Map));

    _habits
      ..clear()
      ..addAll(
        (decoded['habits'] as List<dynamic>).map((item) =>
            HabitModel.fromJson(Map<String, dynamic>.from(item as Map))),
      );
    _journalEntries
      ..clear()
      ..addAll(
        (decoded['journalEntries'] as List<dynamic>).map(
          (item) => JournalEntryModel.fromJson(
              Map<String, dynamic>.from(item as Map)),
        ),
      );
    _completions
      ..clear()
      ..addAll(
        (decoded['completions'] as List<dynamic>).map((item) =>
            CompletionModel.fromJson(Map<String, dynamic>.from(item as Map))),
      );

    await _persistAll();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    _habits.clear();
    _journalEntries.clear();
    _completions.clear();
    await _persistAll();
    notifyListeners();
  }

  int currentStreakForHabit(String habitId) =>
      habitById(habitId)?.currentStreak ?? 0;

  int bestStreakForHabit(String habitId) => habitById(habitId)?.bestStreak ?? 0;

  List<HabitModel> searchHabits(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return activeHabits;
    return activeHabits.where((habit) {
      return habit.name.toLowerCase().contains(normalized) ||
          habit.description.toLowerCase().contains(normalized) ||
          habit.category.toLowerCase().contains(normalized);
    }).toList();
  }

  List<HabitModel> habitsForCategory(String categoryId) {
    final category = categoryById(categoryId);
    if (category == null) return [];
    return activeHabits
        .where((habit) =>
            habit.categoryId == categoryId || habit.category == category.name)
        .toList();
  }

  Future<void> _recalculateHabitStats(String habitId) async {
    final habit = habitById(habitId);
    if (habit == null) return;

    final habitCompletions = completionsForHabit(habitId)
      ..sort((a, b) => a.completedDate.compareTo(b.completedDate));

    final currentStreak = _calculateCurrentStreak(habitCompletions);
    final bestStreak = _calculateBestStreak(habitCompletions);
    final lastCompletedAt = habitCompletions.isEmpty
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : habitCompletions.last.completedDate;

    final updated = habit.copyWith(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastCompletedAt: lastCompletedAt,
      totalCompletions: habitCompletions.length,
      updatedAt: DateTime.now(),
    );

    final index = _habits.indexWhere((item) => item.id == habitId);
    if (index != -1) {
      _habits[index] = updated;
    }
  }

  int _calculateCurrentStreak(List<CompletionModel> habitCompletions) {
    if (habitCompletions.isEmpty) return 0;

    final dates = habitCompletions
        .map((completion) =>
            AppFunction.getMidnightDate(completion.completedDate))
        .toSet()
        .toList()
      ..sort();

    var streak = 1;
    var cursor = dates.last;

    for (var index = dates.length - 2; index >= 0; index--) {
      final expectedPrevious = cursor.subtract(const Duration(days: 1));
      final current = dates[index];
      if (current == expectedPrevious) {
        streak += 1;
        cursor = current;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateBestStreak(List<CompletionModel> habitCompletions) {
    if (habitCompletions.isEmpty) return 0;

    final dates = habitCompletions
        .map((completion) =>
            AppFunction.getMidnightDate(completion.completedDate))
        .toSet()
        .toList()
      ..sort();

    var best = 1;
    var streak = 1;

    for (var index = 1; index < dates.length; index++) {
      final previous = dates[index - 1];
      final current = dates[index];
      if (current.difference(previous).inDays == 1) {
        streak += 1;
      } else {
        if (streak > best) {
          best = streak;
        }
        streak = 1;
      }
    }

    if (streak > best) {
      best = streak;
    }

    return best;
  }

  List<HabitModel> _sortedHabits(List<HabitModel> source) {
    source.sort((a, b) {
      if (a.isCompletedToday() != b.isCompletedToday()) {
        return a.isCompletedToday() ? 1 : -1;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return source;
  }

  void _loadCategories() {
    if (_categories.isEmpty) {
      _categories.addAll(_defaultCategories());
    }
  }

  void _loadHabits() {
    final raw = _storageService.getString(storage.StorageEnum.habits.key);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    _habits
      ..clear()
      ..addAll(
        decoded.map(
          (item) => HabitModel.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  void _loadJournalEntries() {
    final raw =
        _storageService.getString(storage.StorageEnum.journalEntries.key);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    _journalEntries
      ..clear()
      ..addAll(
        decoded.map(
          (item) => JournalEntryModel.fromJson(
              Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  void _loadCompletions() {
    final raw = _storageService.getString(storage.StorageEnum.completions.key);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    _completions
      ..clear()
      ..addAll(
        decoded.map(
          (item) =>
              CompletionModel.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  void _loadSettings() {
    final raw = _storageService.getString(storage.StorageEnum.settings.key);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _loadSettingsFromMap(decoded);
  }

  void _loadSettingsFromMap(Map<String, dynamic> decoded) {
    _onboardingCompleted = decoded['onboardingCompleted'] as bool? ?? false;
    _themeMode = _themeModeFromString(decoded['themeMode'] as String?);
    _weekStartDay = decoded['weekStartDay'] as int? ?? DateTime.monday;
    _soundEnabled = decoded['soundEnabled'] as bool? ?? true;
    _hapticEnabled = decoded['hapticEnabled'] as bool? ?? true;
    _backupEnabled = decoded['backupEnabled'] as bool? ?? false;
    _accentColorHex = decoded['accentColorHex'] as String? ?? '#6366F1';
  }

  Map<String, dynamic> _settingsJson() {
    return <String, dynamic>{
      'onboardingCompleted': _onboardingCompleted,
      'themeMode': _themeMode.name,
      'weekStartDay': _weekStartDay,
      'soundEnabled': _soundEnabled,
      'hapticEnabled': _hapticEnabled,
      'backupEnabled': _backupEnabled,
      'accentColorHex': _accentColorHex,
    };
  }

  ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _persistAll() async {
    await Future.wait([
      _persistHabits(),
      _persistJournalEntries(),
      _persistCompletions(),
      _persistSettings(),
    ]);
  }

  Future<void> _persistHabits() async {
    await _storageService.saveString(
      storage.StorageEnum.habits.key,
      jsonEncode(_habits.map((habit) => habit.toJson()).toList()),
    );
  }

  Future<void> _persistJournalEntries() async {
    await _storageService.saveString(
      storage.StorageEnum.journalEntries.key,
      jsonEncode(_journalEntries.map((entry) => entry.toJson()).toList()),
    );
  }

  Future<void> _persistCompletions() async {
    await _storageService.saveString(
      storage.StorageEnum.completions.key,
      jsonEncode(
          _completions.map((completion) => completion.toJson()).toList()),
    );
  }

  Future<void> _persistSettings() async {
    await _storageService.saveString(
      storage.StorageEnum.settings.key,
      jsonEncode(_settingsJson()),
    );
  }

  void _seedDemoData() {
    final now = DateTime.now();
    _habits.addAll([
      HabitModel(
        id: AppFunction.generateUuid(),
        name: 'Drink water',
        description: 'Stay hydrated throughout the day',
        icon: '💧',
        color: '#3B82F6',
        categoryId: 'health',
        category: 'Health',
        schedule: storage.HabitSchedule.daily,
        reminderEnabled: true,
        reminderTime: '08:00',
        createdAt: now,
        updatedAt: now,
        lastCompletedAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      HabitModel(
        id: AppFunction.generateUuid(),
        name: 'Read 20 minutes',
        description: 'Read before bed to keep your mind sharp',
        icon: '📚',
        color: '#8B5CF6',
        categoryId: 'growth',
        category: 'Growth',
        schedule: storage.HabitSchedule.daily,
        createdAt: now,
        updatedAt: now,
        lastCompletedAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      HabitModel(
        id: AppFunction.generateUuid(),
        name: 'Morning walk',
        description: 'Walk for 20 minutes on weekdays',
        icon: '🚶',
        color: '#10B981',
        categoryId: 'fitness',
        category: 'Fitness',
        schedule: storage.HabitSchedule.weekdays,
        createdAt: now,
        updatedAt: now,
        lastCompletedAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    ]);
  }

  List<CategoryModel> _defaultCategories() {
    final now = DateTime.now();
    return [
      CategoryModel(
        id: 'health',
        name: 'Health',
        color: '#3B82F6',
        icon: '💧',
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'growth',
        name: 'Growth',
        color: '#8B5CF6',
        icon: '📚',
        order: 1,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'fitness',
        name: 'Fitness',
        color: '#10B981',
        icon: '🚶',
        order: 2,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'mindfulness',
        name: 'Mindfulness',
        color: '#F59E0B',
        icon: '🧘',
        order: 3,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}

class TimelineItem {
  TimelineItem._({
    required this.timestamp,
    required this.kind,
    required this.habit,
    this.completion,
    this.journalEntry,
  });

  final DateTime timestamp;
  final TimelineItemKind kind;
  final HabitModel habit;
  final CompletionModel? completion;
  final JournalEntryModel? journalEntry;

  factory TimelineItem.completion({
    required CompletionModel completion,
    required HabitModel habit,
  }) {
    return TimelineItem._(
      timestamp: completion.completedAt,
      kind: TimelineItemKind.completion,
      habit: habit,
      completion: completion,
    );
  }

  factory TimelineItem.journal({
    required JournalEntryModel journalEntry,
    required HabitModel habit,
  }) {
    return TimelineItem._(
      timestamp: journalEntry.createdAt,
      kind: TimelineItemKind.journal,
      habit: habit,
      journalEntry: journalEntry,
    );
  }
}

enum TimelineItemKind { completion, journal }
