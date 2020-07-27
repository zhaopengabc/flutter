// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..login = json['login'] as String
    ..password = json['password'] as String
    ..deviceId = json['deviceId'] as num
    ..theme = json['theme'] as num
    ..themeIndex = json['themeIndex'] as num
    ..screenType = json['screenType'] as String
    ..cache = json['cache'] == null
        ? null
        : CacheConfig.fromJson(json['cache'] as Map<String, dynamic>)
    ..lastLogin = json['lastLogin'] as String
    ..locale = json['locale'] as String
    ..userNames = json['userNames'] as List
    ..firstLoad = json['firstLoad'] as bool
    ..ip = json['ip'] as String
    ..sn = json['sn'] as String
    ..mac = json['mac'] as String
    ..mainModelId = json['mainModelId'] as num
    ..isVideoClosed = json['isVideoClosed'] as bool;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'login': instance.login,
      'password': instance.password,
      'deviceId': instance.deviceId,
      'theme': instance.theme,
      'themeIndex': instance.themeIndex,
      'screenType': instance.screenType,
      'cache': instance.cache,
      'lastLogin': instance.lastLogin,
      'locale': instance.locale,
      'userNames': instance.userNames,
      'firstLoad': instance.firstLoad,
      'ip': instance.ip,
      'sn': instance.sn,
      'mac': instance.mac,
      'mainModelId': instance.mainModelId,
      'isVideoClosed': instance.isVideoClosed
    };
