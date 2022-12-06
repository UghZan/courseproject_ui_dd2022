import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String email;
  DateTime createDate;
  String? linkToAvatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createDate,
    this.linkToAvatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
