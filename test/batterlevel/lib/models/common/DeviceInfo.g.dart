// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeviceInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return DeviceInfo()
    ..ip = json['ip'] as String
    ..status = json['status'] as num
    ..data = json['data'] == null
        ? null
        : DeviceData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'status': instance.status,
      'data': instance.data
    };
