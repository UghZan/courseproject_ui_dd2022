import 'package:json_annotation/json_annotation.dart';

part 'attach_model.g.dart';

@JsonSerializable()
class AttachModel {
  final String id;
  final String name;
  final String mimeType;
  final int size;

  const AttachModel({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
  });

  factory AttachModel.fromJson(Map<String, dynamic> json) =>
      _$AttachModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachModelToJson(this);
}
