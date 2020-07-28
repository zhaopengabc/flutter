import 'package:json_annotation/json_annotation.dart';

part 'userFuncs.g.dart';

@JsonSerializable()
class UserFuncs {
    UserFuncs();

    num active;
    num authed;
    String brief;
    num display;
    String endpoint;
    List funcs;
    num id;
    num level;
    String name;
    num order;
    num parentId;
    
    factory UserFuncs.fromJson(Map<String,dynamic> json) => _$UserFuncsFromJson(json);
    Map<String, dynamic> toJson() => _$UserFuncsToJson(this);
}
