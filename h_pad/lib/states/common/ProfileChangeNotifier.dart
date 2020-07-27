import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;
  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

// 用户状态
class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    //print('user?.login != _profile.user?.login ${user?.login != _profile.user?.login}');
    //if (user?.login != _profile.user?.login) {
    _profile.lastLogin = user.login;
    _profile.user = user;
    notifyListeners();
    //}
  }
}

// 主题状态在用户更换APP主题时更新、通知其依赖项，定义如下：
class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes.firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

// APP语言状态
class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (_profile.locale == null) return Locale('zh', 'CH');
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  // 获取当前Locale的字符串表示
  String get locale => _profile.locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}

class UserNames extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  List<User> getUserNames() {
    if (_profile.userNames == null) return List<User>();
    print('_profile.userNames${_profile.userNames}');
    List list = json.decode(json.encode(_profile.userNames));
    return list.map((value) => new User.fromJson(value)).toList();
  }

  ///保存账号，如果重复，就将最近登录账号放在第一个
  set saveUsers(List<User> users) {
    _profile.userNames = users;
    notifyListeners();
  }

  ///删掉单个账号
  void delUser(List<User> users, User user) {
    //List<User> list = _profile.userNames;
    users.removeWhere((item) => user.login == item.login);
    _profile.userNames = users;
    notifyListeners();
  }

  ///去重并维持次序
  void addNoRepeat(List<User> users, User user) {
    // users.forEach((item) {
    //   if (item.login.contains(user.login)) {
    //     print(users.length);
    //     users.remove(item);
    //     print(users.length);
    //   }
    // });
    users.removeWhere((item) => user.login == item.login);
    users.insert(0, user);
    _profile.userNames = users;
    notifyListeners();
  }
}
// 设备列表
// class DeviceList extends ProfileChangeNotifier {

// }
class VideoState extends ProfileChangeNotifier {
  
  // 视频是否暂停播放 1：视频关闭；0：视频开启
  bool get isVideoClosed => _profile.isVideoClosed??false;
  set isVideoClosed(bool value) {
    if (value != _profile.isVideoClosed) {
      _profile.isVideoClosed = value;
      notifyListeners();
    }
  }
}
