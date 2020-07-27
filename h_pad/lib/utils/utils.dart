import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:h_pad/common/common.dart';
import 'package:h_pad/common/component_index.dart';

class Utils {
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('.pop');
  }

  /**
   * 根据传入的图片名称生成的图片地址
   */
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }
  //读取json文件

  /**
   * 补零
   */
  static String addZero(m) {
    return m < 10 ? '0' + m.toString() : m.toString();
  }

  /**
   * 根据时间格式化
   */
  static String formatDate(dataTime) {
    var time = dataTime;
    var year = time.year;
    var month = time.month;
    var day = time.day;
    var hour = time.hour;
    var minute = time.minute;
    var second = time.second;
    return year.toString() +
        '-' +
        addZero(month) +
        '-' +
        addZero(day) +
        ' ' +
        addZero(hour) +
        ':' +
        addZero(minute) +
        ':' +
        addZero(second);
  }

  /*
			描述：时区的换算
			参数：offset时区位置
			使用：东八区calcTime(”+8");
	*/
  static calcTime(offset) {
    // 创建一个本地日期
    var dateTime = new DateTime.now();
    //将当前时间转换为UTC时间。
    var utc = dateTime.toUtc();
    //将本地时间与本地时区偏移值相加得到当前国际标准时间（UTC）。
    var formatUTC = utc.add(new Duration(hours: int.parse(offset)));
    var nd = formatDate(formatUTC);
    return nd;
  }

  /**
   * 根据设计稿尺寸设置宽度
   */
  static setFontSize(size) {
    return ScreenUtil().setSp(size.toDouble());
  }

  /**
   * 根据横竖屏设置宽度
   */
  static setWidth(size) {
    return ScreenUtil().setWidth(size.toDouble());
  }

    /**
   * 根据横竖屏设置高度
   */
  static setHeight(size) {
    return ScreenUtil().setHeight(size.toDouble());
  }

  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  /**
   * 正则表达式校验
   */
  static bool checkRegExp(data, format) {
    RegExp exp = new RegExp(format);
    return exp.hasMatch(data);
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode, dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }
    int count = 0;
    List<String> list = title.split("");
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }

    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  static int getUpdateStatus(String version) {
    String locVersion = AppConfig.version;
    int remote = int.tryParse(version.replaceAll('.', ''));
    int loc = int.tryParse(locVersion.replaceAll('.', ''));
    if (remote <= loc) {
      return 0;
    } else {
      return (remote - loc >= 2) ? -1 : 1;
    }
  }

  static int getLoadStatus(bool hasError, List data) {
    // if (hasError) return LoadStatus.fail;
    // if (data == null) {
    //   return LoadStatus.loading;
    // } else if (data.isEmpty) {
    //   return LoadStatus.empty;
    // } else {
    //   return LoadStatus.success;
    // }
    return null;
  }

  /**
   * 中间截取字符串并显示"……"
   */
  static String getSubStrName(str, startLen, double maxLen) {
    if (str != null && startLen > str.length) {
      return str;
    }
    var len = str.length;
    var result = str;
    var pre = str.substring(0, startLen);
    if (len > (maxLen / setFontSize(32)).toInt()) {
      result =
          pre + "…" + str.substring(len - ((maxLen - (startLen - 3) * setFontSize(32)) / setFontSize(32)).toInt(), len);
    }
    return result;
  }

//获取当前时间，格式YYYY-MM-DD
  static String getFormatDate() {
    var date = new DateTime.now();
    var year = date.year;
    String month = (date.month + 1).toString();
    String day = date.day.toString();
    ;
    return year.toString() + '-' + addZero(month) + '-' + addZero(day);
  }

  static bool isNull(dynamic obj) {
    return obj == null;
  }

  static bool isNotNull(dynamic obj) {
    return obj != null;
  }

  /**
   * 生成当前时区时间
   */
  static String getTimeZoneToTime(timeZone) {
    var timeZoneName = timeZone;
    var currentTime = Utils.calcTime(timeZoneName.split('UTC')[1].split(':')[0]);
    return currentTime.toString();
  }

  /**
   * 根据横竖屏控制状态栏的显示
   */
  static setEnabledSystemUIOverlays(screenType) {
    if (screenType == 'Horizontal') {
      //隐藏状态栏
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      //显示状态栏
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }

  /**
   * 判断是否是横屏
   */
  static isHorizontal(context) {
    return MediaQuery.of(context).size.width - MediaQuery.of(context).size.height > 0;
  }

  /**
   * 判断是否是Ipad
   */
  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }

  /**
   * 判断是否是永久有效
   */
  static conversionEndTime(endDate) {
    var endTime = endDate;
    if (endDate == '4016-06-06') {
      endTime = '永久有效';
    }
    return endTime;
  }

  /**
   * 检测是否是连续数字或者字符
   */
  static checkIsConsecutive(str) {
    List arr = (str += '').split('');
    int index = 0;
    bool flag = arr.every((item) {
      index++;
      if (index + 1 == arr.length) {
        index -= 1;
      }
      return (arr[index].codeUnits[0] + 1).toString() == arr[index + 1].codeUnits[0].toString() ||
          (arr[index].codeUnits[0] - 1).toString() == arr[index + 1].codeUnits[0].toString();
    });
    if (!flag) {
      index = 0;
      flag = arr.every((item) {
        index++;
        if (index + 1 == arr.length) {
          index -= 1;
        }
        return arr[index] == arr[index + 1];
      });
    }
    return flag;
  }
}

class Post {
  final String version;
  final Map config_info;
  Post({this.version, this.config_info});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      version: json['version'],
      config_info: json['config_info'],
    );
  }
}

class GetJson {
  final url;
  GetJson({this.url}) {}
  static Future<String> _loadPersonJson() async {
    return await rootBundle.loadString('locale/api.json');
  }

  static Future<Post> decodePerson() async {
    // 获取本地的 json 字符串
    String personJson = await _loadPersonJson();
    final jsonMap = json.decode(personJson);
    return Post.fromJson(jsonMap);
  }
}
//  var json = GetJson.decodePerson();
//     json.then((Post) => {
//       print(Post.config_info)
//     });
