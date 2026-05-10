import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

/// Category model for organizing habits
@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String color;
  final String? icon;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.color = '#6366F1',
    this.icon,
    this.order = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Copy with
  CategoryModel copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
