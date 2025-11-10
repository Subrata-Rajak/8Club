import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/experience.dart';

part 'experience_model.g.dart';

/// ExperienceModel - data layer representation with JSON serialization
@JsonSerializable(fieldRename: FieldRename.snake)
class ExperienceModel extends Experience {
  const ExperienceModel({
    required super.id,
    required super.name,
    super.tagline,
    super.description,
    super.imageUrl,
    super.iconUrl,
    required super.order,
  }) : super();

  factory ExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceModelToJson(this);

  /// Convert to domain entity
  Experience toEntity() {
    return Experience(
      id: id,
      name: name,
      tagline: tagline,
      description: description,
      imageUrl: imageUrl,
      iconUrl: iconUrl,
      order: order,
    );
  }
}

