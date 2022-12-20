// ignore_for_file: depend_on_referenced_packages

import 'package:courseproject_ui_dd2022/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_photo.g.dart';

@JsonSerializable()
class PostPhoto implements DbModel {
  @override
  final String id;
  final String name;
  final String mimeType;
  final String? postId;
  final String url;

  PostPhoto({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.url,
    this.postId,
  });

  factory PostPhoto.fromJson(Map<String, dynamic> json) =>
      _$PostPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PostPhotoToJson(this);

  @override
  Map<String, dynamic> toMap() => _$PostPhotoToJson(this);

  factory PostPhoto.fromMap(Map<String, dynamic> map) =>
      _$PostPhotoFromJson(map);

  PostPhoto copyWith({
    String? id,
    String? name,
    String? mimeType,
    String? url,
    String? postId,
  }) {
    return PostPhoto(
      id: id ?? this.id,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      url: url ?? this.url,
      postId: postId ?? this.postId,
    );
  }
}
