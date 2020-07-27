// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userFuncs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFuncs _$UserFuncsFromJson(Map<String, dynamic> json) {
  return UserFuncs()
    ..active = json['active'] as num
    ..authed = json['authed'] as num
    ..brief = json['brief'] as String
    ..display = json['display'] as num
    ..endpoint = json['endpoint'] as String
    ..funcs = json['funcs'] as List
    ..id = json['id'] as num
    ..level = json['level'] as num
    ..name = json['name'] as String
    ..order = json['order'] as num
    ..parentId = json['parentId'] as num;
}

Map<String, dynamic> _$UserFuncsToJson(UserFuncs instance) => <String, dynamic>{
      'active': instance.active,
      'authed': instance.authed,
      'brief': instance.brief,
      'display': instance.display,
      'endpoint': instance.endpoint,
      'funcs': instance.funcs,
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'order': instance.order,
      'parentId': instance.parentId
    };
