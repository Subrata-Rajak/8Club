// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceModel _$ExperienceModelFromJson(Map<String, dynamic> json) =>
    ExperienceModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      tagline: json['tagline'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$ExperienceModelToJson(ExperienceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'icon_url': instance.iconUrl,
      'order': instance.order,
    };
