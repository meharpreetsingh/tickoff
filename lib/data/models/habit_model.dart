import 'package:json_annotation/json_annotation.dart';
import '../../utils/enums/storage_enums.dart';

part 'habit_model.g.dart';

/// Habit model
@JsonSerializable()
class HabitModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final String? categoryId;
  final String category;
  final HabitSchedule schedule;
  final List<int>? customDays; // For custom schedule (0-6, where 0 is Monday)
  final int? timesPerWeek; // For X times per week schedule
  final String? reminderTime; // HH:mm format
  final bool reminderEnabled;
  final bool archived;
  final bool paused;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int currentStreak;
  final int bestStreak;
  final DateTime lastCompletedAt;
  final int totalCompletions;
  final List<String>? journalEntryIds;

  HabitModel({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = '📝',
    this.color = '#6366F1',
    this.categoryId,
    this.category = 'General',
    this.schedule = HabitSchedule.daily,
    this.customDays,
    this.timesPerWeek,
    this.reminderTime,
    this.reminderEnabled = false,
    this.archived = false,
    this.paused = false,
    required this.createdAt,
    required this.updatedAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
    required this.lastCompletedAt,
    this.totalCompletions = 0,
    this.journalEntryIds,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$HabitModelToJson(this);

  /// Create from JSON
  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  /// Copy with
  HabitModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? categoryId,
    String? category,
    HabitSchedule? schedule,
    List<int>? customDays,
    int? timesPerWeek,
    String? reminderTime,
    bool? reminderEnabled,
    bool? archived,
    bool? paused,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCompletedAt,
    int? totalCompletions,
    List<String>? journalEntryIds,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      schedule: schedule ?? this.schedule,
      customDays: customDays ?? this.customDays,
      timesPerWeek: timesPerWeek ?? this.timesPerWeek,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      archived: archived ?? this.archived,
      paused: paused ?? this.paused,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      journalEntryIds: journalEntryIds ?? this.journalEntryIds,
    );
  }

  /// Check if habit is due today
  bool isDueToday({int weekStartDay = 1}) {
    final today = DateTime.now();

    if (archived || paused) return false;

    switch (schedule) {
      case HabitSchedule.daily:
        return true;

      case HabitSchedule.weekdays:
        return today.weekday >= 1 && today.weekday <= 5;

      case HabitSchedule.weekends:
        return today.weekday >= 6;

      case HabitSchedule.custom:
        if (customDays != null) {
          final todayWeekday = (today.weekday - weekStartDay) % 7;
          return customDays!.contains(todayWeekday);
        }
        return false;
    }
  }

  /// Check if completed today
  bool isCompletedToday() {
    final today = DateTime.now();
    final lastCompleted = lastCompletedAt;

    return lastCompleted.year == today.year &&
        lastCompleted.month == today.month &&
        lastCompleted.day == today.day;
  }

  @override
  String toString() =>
      'HabitModel(id: $id, name: $name, streak: $currentStreak)';
}
