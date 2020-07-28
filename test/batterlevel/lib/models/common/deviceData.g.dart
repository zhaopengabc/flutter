// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) {
  return DeviceData()
    ..modeId = json['modeId'] as num
    ..sn = json['sn'] as String;
}

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{'modeId': instance.modeId, 'sn': instance.sn};
