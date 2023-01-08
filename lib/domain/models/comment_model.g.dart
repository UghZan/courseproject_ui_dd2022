// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      postContent: json['postContent'] as String?,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      creationDate: json['creationDate'] as String,
      reactionsCount: json['reactionsCount'] as int,
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postContent': instance.postContent,
      'author': instance.author,
      'creationDate': instance.creationDate,
      'reactionsCount': instance.reactionsCount,
      'postId': instance.postId,
    };
