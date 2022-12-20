// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachModel _$AttachModelFromJson(Map<String, dynamic> json) => AttachModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      size: json['size'] as int,
    );

Map<String, dynamic> _$AttachModelToJson(AttachModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'size': instance.size,
    };
