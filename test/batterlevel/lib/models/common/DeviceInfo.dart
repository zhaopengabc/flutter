import 'package:json_annotation/json_annotation.dart';
import "deviceData.dart";
part 'DeviceInfo.g.dart';

@JsonSerializable()
class DeviceInfo {
    DeviceInfo();

    String ip;
    num status;
    DeviceData data;
    
    factory DeviceInfo.fromJson(Map<String,dynamic> json) => _$DeviceInfoFromJson(json);
    Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}
