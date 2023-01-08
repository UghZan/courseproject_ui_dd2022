// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'create_reaction_model.g.dart';

@JsonSerializable()
class CreateReactionModel {
  final int reactionType;

  CreateReactionModel({required this.reactionType});

  factory CreateReactionModel.fromJson(Map<String, dynamic> json) =>
      _$CreateReactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReactionModelToJson(this);
}
