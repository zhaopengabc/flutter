import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:logging/logging.dart';
import 'package:orientation/orientation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static String _baseUrl;
  static String _wsUrl;
  static String _token;
  static String _videoUrl;

  static String _screenType;
  static bool _firstLoad;
  // static DartEventBus bus;
  static Logger log = new Logger(r"main");
  static SharedPreferences _prefs;
  static Profile profile = Profile(); // 本地存储的数据
  // static List<User> _userNames;
  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static Timer secondTimer;
  static String _remainingTime;
  static String get remainingTime => _remainingTime;
  // 初始化全局信息，会在APP启动时执行
  static Future init() async {
    // bus = new DartEventBus();
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('name: ${rec.level.name}, time: ${rec.time}, message:  ${rec.message}');
      if (rec.error != null && rec.stackTrace != null) {
        print('error${rec.error}, stackTrace: ${rec.stackTrace}');
      }
    });

    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    _remainingTime = _prefs.getString('authTime');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        // 登录用户列表
        // _userNames = profile.userNames != null ? profile.userNames : [];
      } catch (e) {
        print('glable - err$e');
      }
    }
    // 首次 登录
    _firstLoad = profile.firstLoad;

    // 横竖屏
    OrientationPlugin.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // OrientationPlugin.forceOrientation(DeviceOrientation.landscapeLeft);
    if (profile.screenType == null) {
      _screenType = 'Horizontal';
      profile.screenType = 'Horizontal';
      Utils.setEnabledSystemUIOverlays(_screenType);
      saveProfile();
    }

    // 初始化 国际化
    await LoadJson.init();
  }

  static set firstLoads(bool value) {
    _firstLoad = value;
  }

  //是否首次加
  static get firstLoad => _firstLoad; //是否首次加载

  // baseurl
  static set setBaseUrl(String value) {
    _baseUrl = value;
  }

  static get getBaseUrl => _baseUrl;

  // wesocket url
  static set setWSUrl(String value) {
    _wsUrl = value;
  }

  static get getWSUrl => _wsUrl;

  //token  获取和存储
  static set setToken(String value) {
    _token = value;
  }


  static get getVideoUrl => _videoUrl;
  // 视频 url
  static setVideoUrl(String value) {
    _videoUrl = value;
  }

  // static get getUserNames => _userNames;
  // //token  获取和存储
  // static set setUserNames(List<User> userNames) {
  //   _userNames = userNames;
  // }

  // ///删掉单个账号
  // static void delUser(User user) {
  //   _userNames.remove(user);
  //   saveUsers(_userNames);
  // }

  // ///去重并维持次序
  // static void addNoRepeat(User user) {
  //   if (_userNames.contains(user)) {
  //     _userNames.remove(user);
  //   }
  //   _userNames.insert(0, user);
  //   saveUsers(_userNames);
  // }

  // ///保存账号列表
  // static saveUsers(List<User> users) {
  //   _userNames = users;
  //   saveUserNames();
  // }

  static get getToken => _token;
  // 根据 （持久化登录用户信息 ）
  // static saveUserNames() => _prefs.setString('userNames', jsonEncode(_userNames));
  // 持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
  static saveAuthTime(String value) => _prefs.setString("authTime",value);
}
