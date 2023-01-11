// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createDate: json['createDate'] as String,
      linkToAvatar: json['linkToAvatar'] as String?,
      subscribersCount: json['subscribersCount'] as int,
      subscriptionsCount: json['subscriptionsCount'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'createDate': instance.createDate,
      'linkToAvatar': instance.linkToAvatar,
      'subscribersCount': instance.subscribersCount,
      'subscriptionsCount': instance.subscriptionsCount,
    };
