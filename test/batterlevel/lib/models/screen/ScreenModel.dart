import 'package:flutter/cupertino.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'OutPutModel.dart';

class ScreenModel {
  int deviceId;
  Bkg bkg;
  Freeze freeze;
  Ftb ftb;
  Osd osd;
  int brightness;
  num gamma;
  ScreenGeneral general;
  ImageQuality imageQuality;
  int mayUse;
  OutputMode outputMode;
  PresetPoll presetPoll;
  int screenBrightness;
  int screenId;
  int isLock = 0; // 是否锁屏 0 - 未锁屏 1- 锁屏
  List<ScreenLayer> screenLayers = new List<ScreenLayer>();
  SwitchEffect switchEffect;
  TestPattern testPattern;

  ScreenModel(
      {this.screenId,
      this.general,
      this.screenLayers,
      this.outputMode,
      this.freeze,
      this.bkg});
  bool isCurrentScreen = false;

  ScreenModel.fromJson(Map<String, dynamic> json) {
    bkg = json['Bkg'] != null ? new Bkg.fromJson(json['Bkg']) : null;
    freeze =
        json['Freeze'] != null ? new Freeze.fromJson(json['Freeze']) : null;
    ftb = json['Ftb'] != null ? new Ftb.fromJson(json['Ftb']) : null;
    osd = json['Osd'] != null ? new Osd.fromJson(json['Osd']) : null;
    brightness = json['brightness'];
    deviceId = json['deviceId'];
    gamma = json['gamma'];
    general = json['general'] != null
        ? new ScreenGeneral.fromJson(json['general'])
        : null;
    // imageQuality = json['imageQuality'] != null
    //     ? new ImageQuality.fromJson(json['imageQuality'])
    //     : null;
    mayUse = json['mayUse'];
    outputMode = json['outputMode'] != null
        ? new OutputMode.fromJson(json['outputMode'])
        : null;
    presetPoll = json['presetPoll'] != null
        ? new PresetPoll.fromJson(json['presetPoll'])
        : null;
    screenBrightness = json['screenBrightness'];
    screenId = json['screenId'];
    if (json['screenLayers'] != null) {
      screenLayers = new List<ScreenLayer>();
      json['screenLayers'].forEach((v) {
        screenLayers.add(new ScreenLayer.fromJson(v));
      });
    }
    switchEffect = json['switchEffect'] != null
        ? new SwitchEffect.fromJson(json['switchEffect'])
        : null;
    testPattern = json['testPattern'] != null
        ? new TestPattern.fromJson(json['testPattern'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'screenId': screenId,
        'general': general,
      };
}

class ScreenGeneral {
  String creatTime;
  String screenName;
  ScreenGeneral({this.creatTime, this.screenName});
  factory ScreenGeneral.fromJson(Map<String, dynamic> json) {
    return ScreenGeneral(
        creatTime: json['createTime'], screenName: json['name']);
  }

  Map<String, dynamic> toJson() =>
      {'creatTime': creatTime, 'screenName': screenName};
}

class Bkg {
  int bkgId;
  int enable;
  String imgUrl;
  Bkg({this.bkgId, this.enable, this.imgUrl});
  factory Bkg.fromJson(Map<String, dynamic> json) {
    return Bkg(
        bkgId: json['bkgId'], enable: json['enable'], imgUrl: json['imgUrl']);
  }
}

class Freeze {
  int enable;
  Freeze({this.enable});
  factory Freeze.fromJson(Map<String, dynamic> json) {
    return Freeze(enable: json['enable']);
  }
}

class Ftb {
  int enable;
  Ftb({this.enable});
  factory Ftb.fromJson(Map<String, dynamic> json) {
    return Ftb(enable: json['enable']);
  }
}
class FtbWebSocket {
  int screenId;
  int deviceId;
  int type;
  num time;

  FtbWebSocket({this.screenId, this.deviceId, this.type, this.time});

  FtbWebSocket.fromJson(Map<String, dynamic> json) {
    screenId = json['screenId'];
    deviceId = json['deviceId'];
    type = json['type'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screenId'] = this.screenId;
    data['deviceId'] = this.deviceId;
    data['type'] = this.type;
    data['time'] = this.time;
    return data;
  }
}

class Osd {
  int enable;
  int height;
  OsdImage image;
  int type;
  int width;
  int x;
  int y;

  Osd({this.enable, this.height, this.image});
  factory Osd.fromJson(Map<String, dynamic> json) {
    return Osd(
        enable: json['enable'],
        height: json['height'],
        image: json['image'] != null ? OsdImage.fromJson(json['image']) : null);
  }
}

class OsdImage {
  File file;
  int opacity;

  OsdImage({this.file, this.opacity});

  OsdImage.fromJson(Map<String, dynamic> json) {
    file = json['file'] != null ? new File.fromJson(json['file']) : null;
    opacity = json['opacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.file != null) {
      data['file'] = this.file.toJson();
    }
    data['opacity'] = this.opacity;
    return data;
  }
}

class File {
  int fileLength;
  String fileName;
  int hashSum;
  int height;
  int width;

  File({this.fileLength, this.fileName, this.hashSum, this.height, this.width});

  File.fromJson(Map<String, dynamic> json) {
    fileLength = json['fileLength'];
    fileName = json['fileName'];
    hashSum = json['hashSum'];
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileLength'] = this.fileLength;
    data['fileName'] = this.fileName;
    data['hashSum'] = this.hashSum;
    data['height'] = this.height;
    data['width'] = this.width;
    return data;
  }
}

class Words {
  BackgroundColor backgroundColor;
  int backgroundEnable;
  BackgroundImage backgroundImage;
  int backgroundType;
  String chars;
  int direction;
  int font;
  BackgroundColor fontColor;
  int fontPercent;
  int speed;

  Words(
      {this.backgroundColor,
      this.backgroundEnable,
      this.backgroundImage,
      this.backgroundType,
      this.chars,
      this.direction,
      this.font,
      this.fontColor,
      this.fontPercent,
      this.speed});

  Words.fromJson(Map<String, dynamic> json) {
    backgroundColor = json['backgroundColor'] != null
        ? new BackgroundColor.fromJson(json['backgroundColor'])
        : null;
    backgroundEnable = json['backgroundEnable'];
    backgroundImage = json['backgroundImage'] != null
        ? new BackgroundImage.fromJson(json['backgroundImage'])
        : null;
    backgroundType = json['backgroundType'];
    chars = json['chars'];
    direction = json['direction'];
    font = json['font'];
    fontColor = json['fontColor'] != null
        ? new BackgroundColor.fromJson(json['fontColor'])
        : null;
    fontPercent = json['fontPercent'];
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.backgroundColor != null) {
      data['backgroundColor'] = this.backgroundColor.toJson();
    }
    data['backgroundEnable'] = this.backgroundEnable;
    if (this.backgroundImage != null) {
      data['backgroundImage'] = this.backgroundImage.toJson();
    }
    data['backgroundType'] = this.backgroundType;
    data['chars'] = this.chars;
    data['direction'] = this.direction;
    data['font'] = this.font;
    if (this.fontColor != null) {
      data['fontColor'] = this.fontColor.toJson();
    }
    data['fontPercent'] = this.fontPercent;
    data['speed'] = this.speed;
    return data;
  }
}

class BackgroundColor {
  int a;
  int b;
  int g;
  int r;

  BackgroundColor({this.a, this.b, this.g, this.r});

  BackgroundColor.fromJson(Map<String, dynamic> json) {
    a = json['A'];
    b = json['B'];
    g = json['G'];
    r = json['R'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['A'] = this.a;
    data['B'] = this.b;
    data['G'] = this.g;
    data['R'] = this.r;
    return data;
  }
}

class BackgroundImage {
  File file;
  int opacity;

  BackgroundImage({this.file, this.opacity});

  BackgroundImage.fromJson(Map<String, dynamic> json) {
    file = json['file'] != null ? new File.fromJson(json['file']) : null;
    opacity = json['opacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.file != null) {
      data['file'] = this.file.toJson();
    }
    data['opacity'] = this.opacity;
    return data;
  }
}

// 图片质量
class ImageQuality {
  Brightness brightness;
  Contrast contrast;
  int hue;
  int saturation;
  ImageQuality({this.brightness, this.contrast, this.hue, this.saturation});
  ImageQuality.fromJson(Map<String, dynamic> json) {
    brightness = json['brightness'] != null
        ? new Brightness.fromJson(json['brightness'])
        : null;
    contrast = json['contrast'] != null
        ? new Contrast.fromJson(json['contrast'])
        : null;
    hue = json['hue'];
    saturation = json['saturation'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brightness != null) {
      data['brightness'] = this.brightness.toJson();
    }
    if (this.contrast != null) {
      data['contrast'] = this.contrast.toJson();
    }
    data['hue'] = this.hue;
    data['saturation'] = this.saturation;
    return data;
  }
}

class Brightness {
  int b;
  int g;
  int r;
  int all;
  Brightness({this.b, this.g, this.r, this.all});
  Brightness.fromJson(Map<String, dynamic> json) {
    b = json['B'];
    g = json['G'];
    r = json['R'];
    all = json['all'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['B'] = this.b;
    data['G'] = this.g;
    data['R'] = this.r;
    data['all'] = this.all;
    return data;
  }
}

class Contrast {
  int b;
  int g;
  int r;
  int all;

  Contrast({this.b, this.g, this.r, this.all});

  Contrast.fromJson(Map<String, dynamic> json) {
    b = json['B'];
    g = json['G'];
    r = json['R'];
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['B'] = this.b;
    data['G'] = this.g;
    data['R'] = this.r;
    data['all'] = this.all;
    return data;
  }
}

class PresetPoll {
  int enable;
  int presetGroupId;

  PresetPoll({this.enable, this.presetGroupId});

  PresetPoll.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    presetGroupId = json['presetGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enable'] = this.enable;
    data['presetGroupId'] = this.presetGroupId;
    return data;
  }
}

class SwitchEffect {
  int playPGMIndex;
  int effectType;
  int switchEffect;
  int timeline;

  SwitchEffect(
      {this.playPGMIndex, this.effectType, this.switchEffect, this.timeline});

  SwitchEffect.fromJson(Map<String, dynamic> json) {
    playPGMIndex = json['PlayPGMIndex'];
    effectType = json['effectType'];
    switchEffect = json['switchEffect'];
    timeline = json['timeline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PlayPGMIndex'] = this.playPGMIndex;
    data['effectType'] = this.effectType;
    data['switchEffect'] = this.switchEffect;
    data['timeline'] = this.timeline;
    return data;
  }
}

class TestPattern {
  int bright;
  int grid;
  int speed;
  int testPattern;

  TestPattern({this.bright, this.grid, this.speed, this.testPattern});

  TestPattern.fromJson(Map<String, dynamic> json) {
    bright = json['bright'];
    grid = json['grid'];
    speed = json['speed'];
    testPattern = json['testPattern'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bright'] = this.bright;
    data['grid'] = this.grid;
    data['speed'] = this.speed;
    data['testPattern'] = this.testPattern;
    return data;
  }
}
