// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '📝',
      color: json['color'] as String? ?? '#6366F1',
      categoryId: json['categoryId'] as String?,
      category: json['category'] as String? ?? 'General',
      schedule: $enumDecodeNullable(_$HabitScheduleEnumMap, json['schedule']) ??
          HabitSchedule.daily,
      customDays: (json['customDays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      timesPerWeek: (json['timesPerWeek'] as num?)?.toInt(),
      reminderTime: json['reminderTime'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
      paused: json['paused'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      lastCompletedAt: DateTime.parse(json['lastCompletedAt'] as String),
      totalCompletions: (json['totalCompletions'] as num?)?.toInt() ?? 0,
      journalEntryIds: (json['journalEntryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'schedule': _$HabitScheduleEnumMap[instance.schedule]!,
      'customDays': instance.customDays,
      'timesPerWeek': instance.timesPerWeek,
      'reminderTime': instance.reminderTime,
      'reminderEnabled': instance.reminderEnabled,
      'archived': instance.archived,
      'paused': instance.paused,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
      'lastCompletedAt': instance.lastCompletedAt.toIso8601String(),
      'totalCompletions': instance.totalCompletions,
      'journalEntryIds': instance.journalEntryIds,
    };

const _$HabitScheduleEnumMap = {
  HabitSchedule.daily: 'daily',
  HabitSchedule.weekdays: 'weekdays',
  HabitSchedule.weekends: 'weekends',
  HabitSchedule.custom: 'custom',
};
