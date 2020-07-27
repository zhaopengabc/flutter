import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
    Login();

    num deviceId;
    num isAdmin;
    String token;
    List userFuncs;
    num userId;
    String userName;
    
    factory Login.fromJson(Map<String,dynamic> json) => _$LoginFromJson(json);
    Map<String, dynamic> toJson() => _$LoginToJson(this);
}
