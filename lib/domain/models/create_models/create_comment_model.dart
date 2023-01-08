// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'create_comment_model.g.dart';

@JsonSerializable()
class CreateCommentModel {
  final String postContent;

  CreateCommentModel({required this.postContent});

  factory CreateCommentModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCommentModelToJson(this);
}
