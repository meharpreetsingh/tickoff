import 'package:json_annotation/json_annotation.dart';

part 'journal_entry_model.g.dart';

/// Journal entry model
@JsonSerializable()
class JournalEntryModel {
  final String id;
  final String habitId;
  final String? note;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntryModel({
    required this.id,
    required this.habitId,
    this.note,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$JournalEntryModelToJson(this);

  /// Create from JSON
  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);

  /// Copy with
  JournalEntryModel copyWith({
    String? id,
    String? habitId,
    String? note,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if entry has content
  bool hasContent() {
    return (note != null && note!.isNotEmpty) ||
        (photoPath != null && photoPath!.isNotEmpty);
  }

  @override
  String toString() =>
      'JournalEntryModel(id: $id, habitId: $habitId, note: ${note?.length ?? 0} chars)';
}
