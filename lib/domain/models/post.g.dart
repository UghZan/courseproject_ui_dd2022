// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      postContent: json['postContent'] as String,
      authorId: json['authorId'] as String?,
      creationDate: json['creationDate'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'postContent': instance.postContent,
      'authorId': instance.authorId,
      'creationDate': instance.creationDate,
    };
