// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login()
    ..deviceId = json['deviceId'] as num
    ..isAdmin = json['isAdmin'] as num
    ..token = json['token'] as String
    ..userFuncs = json['userFuncs'] as List
    ..userId = json['userId'] as num
    ..userName = json['userName'] as String;
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'isAdmin': instance.isAdmin,
      'token': instance.token,
      'userFuncs': instance.userFuncs,
      'userId': instance.userId,
      'userName': instance.userName
    };
