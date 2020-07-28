// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initstates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Initstates _$InitstatesFromJson(Map<String, dynamic> json) {
  return Initstates()
    ..initStatus = json['initStatus'] as num
    ..languageMode = json['languageMode'] as num
    ..mainModelId = json['mainModelId'] as num
    ..nomarkMode = json['nomarkMode'] as Map<String, dynamic>;
}

Map<String, dynamic> _$InitstatesToJson(Initstates instance) =>
    <String, dynamic>{
      'initStatus': instance.initStatus,
      'languageMode': instance.languageMode,
      'mainModelId': instance.mainModelId,
      'nomarkMode': instance.nomarkMode
    };
