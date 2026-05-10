import 'package:json_annotation/json_annotation.dart';

part 'completion_model.g.dart';

/// Completion model for tracking habit completions
@JsonSerializable()
class CompletionModel {
  final String id;
  final String habitId;
  final DateTime completedDate;
  final DateTime completedAt;
  final bool freezeUsed;
  final DateTime createdAt;

  CompletionModel({
    required this.id,
    required this.habitId,
    required this.completedDate,
    required this.completedAt,
    this.freezeUsed = false,
    required this.createdAt,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CompletionModelToJson(this);

  /// Create from JSON
  factory CompletionModel.fromJson(Map<String, dynamic> json) =>
      _$CompletionModelFromJson(json);

  /// Copy with
  CompletionModel copyWith({
    String? id,
    String? habitId,
    DateTime? completedDate,
    DateTime? completedAt,
    bool? freezeUsed,
    DateTime? createdAt,
  }) {
    return CompletionModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      completedDate: completedDate ?? this.completedDate,
      completedAt: completedAt ?? this.completedAt,
      freezeUsed: freezeUsed ?? this.freezeUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if completion is for today
  bool isToday() {
    final today = DateTime.now();
    return completedDate.year == today.year &&
        completedDate.month == today.month &&
        completedDate.day == today.day;
  }

  @override
  String toString() =>
      'CompletionModel(habitId: $habitId, date: $completedDate, freeze: $freezeUsed)';
}
