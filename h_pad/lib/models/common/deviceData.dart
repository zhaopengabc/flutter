import 'package:json_annotation/json_annotation.dart';

part 'deviceData.g.dart';

@JsonSerializable()
class DeviceData {
    DeviceData();

    num modeId;
    String sn;
    
    factory DeviceData.fromJson(Map<String,dynamic> json) => _$DeviceDataFromJson(json);
    Map<String, dynamic> toJson() => _$DeviceDataToJson(this);
}
