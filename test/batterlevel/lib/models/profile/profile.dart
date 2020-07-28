import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "cacheConfig.dart";
part 'profile.g.dart';

@JsonSerializable()
class Profile {
    Profile();

    User user;
    String login;
    String password;
    num deviceId;
    num theme;
    num themeIndex;
    String screenType;
    CacheConfig cache;
    String lastLogin;
    String locale;
    List userNames;
    bool firstLoad;
    String ip;
    String sn;
    String mac;
    num mainModelId;
    bool isVideoClosed;
    
    factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
    Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
