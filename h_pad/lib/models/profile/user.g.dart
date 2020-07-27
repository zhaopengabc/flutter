// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..login = json['login'] as String
    ..password = json['password'] as String
    ..isAdmin = json['isAdmin'] as num
    ..userId = json['userId'] as num;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'isAdmin': instance.isAdmin,
      'userId': instance.userId
    };
