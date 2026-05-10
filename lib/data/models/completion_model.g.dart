// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletionModel _$CompletionModelFromJson(Map<String, dynamic> json) =>
    CompletionModel(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      completedDate: DateTime.parse(json['completedDate'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      freezeUsed: json['freezeUsed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CompletionModelToJson(CompletionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habitId': instance.habitId,
      'completedDate': instance.completedDate.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'freezeUsed': instance.freezeUsed,
      'createdAt': instance.createdAt.toIso8601String(),
    };
