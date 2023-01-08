// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment implements DbModel {
  @override
  final String id;
  final String postContent;
  final String? authorId;
  final String creationDate;
  final String? postId;
  final int reactionsCount;

  Comment(
      {required this.id,
      required this.postContent,
      this.authorId,
      this.postId,
      required this.creationDate,
      required this.reactionsCount});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  Map<String, dynamic> toMap() => _$CommentToJson(this);

  factory Comment.fromMap(Map<String, dynamic> map) => _$CommentFromJson(map);

  Comment copyWith(
      {String? id,
      String? postContent,
      String? authorId,
      String? postId,
      String? creationDate,
      int? reactionsCount}) {
    return Comment(
        id: id ?? this.id,
        postContent: postContent ?? this.postContent,
        postId: postId ?? this.postId,
        authorId: authorId ?? this.authorId,
        creationDate: creationDate ?? this.creationDate,
        reactionsCount: reactionsCount ?? this.reactionsCount);
  }
}
