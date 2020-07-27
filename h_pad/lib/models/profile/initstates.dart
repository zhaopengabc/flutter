import 'package:json_annotation/json_annotation.dart';

part 'initstates.g.dart';

@JsonSerializable()
class Initstates {
    Initstates();

    num initStatus;
    num languageMode;
    num mainModelId;
    Map<String,dynamic> nomarkMode;
    
    factory Initstates.fromJson(Map<String,dynamic> json) => _$InitstatesFromJson(json);
    Map<String, dynamic> toJson() => _$InitstatesToJson(this);
}
