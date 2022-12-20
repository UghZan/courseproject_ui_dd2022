// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      postContent: json['postContent'] as String?,
      postAttachments: (json['postAttachments'] as List<dynamic>)
          .map((e) => PostPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      creationDate: json['creationDate'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'postContent': instance.postContent,
      'postAttachments': instance.postAttachments,
      'author': instance.author,
      'creationDate': instance.creationDate,
    };
