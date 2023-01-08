// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postContent: json['postContent'] as String,
      authorId: json['authorId'] as String?,
      postId: json['postId'] as String?,
      creationDate: json['creationDate'] as String,
      reactionsCount: json['reactionsCount'] as int,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postContent': instance.postContent,
      'authorId': instance.authorId,
      'creationDate': instance.creationDate,
      'postId': instance.postId,
      'reactionsCount': instance.reactionsCount,
    };
