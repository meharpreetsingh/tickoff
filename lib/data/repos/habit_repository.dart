import '../../data/models/habit_model.dart';

/// Habit repository abstract interface
abstract class HabitRepository {
  /// Get all habits
  Future<List<HabitModel>> getAllHabits();

  /// Get habit by id
  Future<HabitModel?> getHabitById(String id);

  /// Create habit
  Future<HabitModel> createHabit(HabitModel habit);

  /// Update habit
  Future<HabitModel> updateHabit(HabitModel habit);

  /// Delete habit
  Future<bool> deleteHabit(String id);

  /// Archive habit
  Future<HabitModel> archiveHabit(String id);

  /// Restore habit
  Future<HabitModel> restoreHabit(String id);

  /// Get habits by category
  Future<List<HabitModel>> getHabitsByCategory(String categoryId);

  /// Get today's habits
  Future<List<HabitModel>> getTodayHabits();

  /// Get completed habits for date
  Future<List<HabitModel>> getCompletedHabitsForDate(DateTime date);

  /// Search habits
  Future<List<HabitModel>> searchHabits(String query);
}

/// Habit completion repository abstract interface
abstract class CompletionRepository {
  /// Mark habit as complete
  Future<bool> markComplete(String habitId, DateTime date);

  /// Undo completion
  Future<bool> undoCompletion(String habitId, DateTime date);

  /// Get completions for habit
  Future<List<DateTime>> getCompletionsForHabit(String habitId);

  /// Get completions for date range
  Future<Map<DateTime, List<String>>> getCompletionsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Calculate current streak
  Future<int> calculateCurrentStreak(String habitId);

  /// Calculate best streak
  Future<int> calculateBestStreak(String habitId);
}

/// Journal repository abstract interface
abstract class JournalRepository {
  /// Get entries for habit
  Future<List<JournalModel>> getEntriesForHabit(String habitId);

  /// Get entry by id
  Future<JournalModel?> getEntryById(String id);

  /// Create entry
  Future<JournalModel> createEntry(JournalModel entry);

  /// Update entry
  Future<JournalModel> updateEntry(JournalModel entry);

  /// Delete entry
  Future<bool> deleteEntry(String id);

  /// Get all entries
  Future<List<JournalModel>> getAllEntries();

  /// Search entries
  Future<List<JournalModel>> searchEntries(String query);
}

/// Dummy model for compilation (should be imported from models)
class JournalModel {
  final String id;
  final String habitId;
  final String? note;

  JournalModel({required this.id, required this.habitId, this.note});
}
