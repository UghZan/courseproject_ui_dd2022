// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostModel _$CreatePostModelFromJson(Map<String, dynamic> json) =>
    CreatePostModel(
      postContent: json['postContent'] as String,
      postAttachments: (json['postAttachments'] as List<dynamic>?)
          ?.map((e) => AttachModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreatePostModelToJson(CreatePostModel instance) =>
    <String, dynamic>{
      'postContent': instance.postContent,
      'postAttachments': instance.postAttachments,
    };
