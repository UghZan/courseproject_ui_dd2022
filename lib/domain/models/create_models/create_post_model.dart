// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/domain/models/attach_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  final String postContent;
  final List<AttachModel>? postAttachments;

  CreatePostModel({required this.postContent, this.postAttachments});

  factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);
}
