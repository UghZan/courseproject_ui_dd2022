// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String postContent;
  final String? authorId;
  final String creationDate;
  final int reactionsCount;
  final int commentsCount;

  Post(
      {required this.id,
      required this.postContent,
      this.authorId,
      required this.creationDate,
      required this.reactionsCount,
      required this.commentsCount});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);

  Post copyWith(
      {String? id,
      String? postContent,
      String? authorId,
      String? creationDate,
      int? reactionsCount,
      int? commentsCount,
      int? userReaction}) {
    return Post(
        id: id ?? this.id,
        postContent: postContent ?? this.postContent,
        authorId: authorId ?? this.authorId,
        creationDate: creationDate ?? this.creationDate,
        reactionsCount: reactionsCount ?? this.reactionsCount,
        commentsCount: commentsCount ?? this.commentsCount);
  }
}
