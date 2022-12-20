// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPhoto _$PostPhotoFromJson(Map<String, dynamic> json) => PostPhoto(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      url: json['url'] as String,
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$PostPhotoToJson(PostPhoto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'postId': instance.postId,
      'url': instance.url,
    };
