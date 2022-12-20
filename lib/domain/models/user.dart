// ignore_for_file: depend_on_referenced_packages
import 'package:courseproject_ui_dd2022/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel {
  @override
  String id;
  String name;
  String email;
  String createDate;
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

  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.createDate == createDate &&
        other.linkToAvatar == linkToAvatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        createDate.hashCode ^
        linkToAvatar.hashCode;
  }
}
