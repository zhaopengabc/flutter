/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-02 18:42:16
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-03 15:19:29
 */ 

class OutputModel {
  int cardCategory;
  int connectCapacity;
  int freeze;
  int ftb;
  Gamma gamma;
  General general;
  int iSignal;
  ImageQuality imageQuality;
  int interfaceId;
  int interfaceType;
  int isEDIDSetting;
  int isUsed;
  int modelId;
  int outputId;
  int presetPoll;
  Resolution resolution;
  int slotId;
  TestPattern testPattern;
  Timing timing;

  OutputModel(
      {this.cardCategory,
      this.connectCapacity,
      this.freeze,
      this.ftb,
      this.gamma,
      this.general,
      this.iSignal,
      this.imageQuality,
      this.interfaceId,
      this.interfaceType,
      this.isEDIDSetting,
      this.isUsed,
      this.modelId,
      this.outputId,
      this.presetPoll,
      this.resolution,
      this.slotId,
      this.testPattern,
      this.timing});

  OutputModel.fromJson(Map<String, dynamic> json) {
    cardCategory = json['cardCategory'];
    connectCapacity = json['connectCapacity'];
    freeze = json['freeze'];
    ftb = json['ftb'];
    gamma = json['gamma'] != null ? new Gamma.fromJson(json['gamma']) : null;
    general =
        json['general'] != null ? new General.fromJson(json['general']) : null;
    iSignal = json['iSignal'];
    imageQuality = json['imageQuality'] != null
        ? new ImageQuality.fromJson(json['imageQuality'])
        : null;
    interfaceId = json['interfaceId'];
    interfaceType = json['interfaceType'];
    isEDIDSetting = json['isEDIDSetting'];
    isUsed = json['isUsed'];
    modelId = json['modelId'];
    outputId = json['outputId'];
    presetPoll = json['presetPoll'];
    resolution = json['resolution'] != null
        ? new Resolution.fromJson(json['resolution'])
        : null;
    slotId = json['slotId'];
    testPattern = json['testPattern'] != null
        ? new TestPattern.fromJson(json['testPattern'])
        : null;
    timing =
        json['timing'] != null ? new Timing.fromJson(json['timing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardCategory'] = this.cardCategory;
    data['connectCapacity'] = this.connectCapacity;
    data['freeze'] = this.freeze;
    data['ftb'] = this.ftb;
    if (this.gamma != null) {
      data['gamma'] = this.gamma.toJson();
    }
    if (this.general != null) {
      data['general'] = this.general.toJson();
    }
    data['iSignal'] = this.iSignal;
    if (this.imageQuality != null) {
      data['imageQuality'] = this.imageQuality.toJson();
    }
    data['interfaceId'] = this.interfaceId;
    data['interfaceType'] = this.interfaceType;
    data['isEDIDSetting'] = this.isEDIDSetting;
    data['isUsed'] = this.isUsed;
    data['modelId'] = this.modelId;
    data['outputId'] = this.outputId;
    data['presetPoll'] = this.presetPoll;
    if (this.resolution != null) {
      data['resolution'] = this.resolution.toJson();
    }
    data['slotId'] = this.slotId;
    if (this.testPattern != null) {
      data['testPattern'] = this.testPattern.toJson();
    }
    if (this.timing != null) {
      data['timing'] = this.timing.toJson();
    }
    return data;
  }
}

class Gamma {
  double gamma;

  Gamma({this.gamma});

  Gamma.fromJson(Map<String, dynamic> json) {
    gamma = json['gamma'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gamma'] = this.gamma;
    return data;
  }
}

class General {
  int colorDepth;
  int colorSpace;
  String name;
  int sampleRate;

  General({this.colorDepth, this.colorSpace, this.name, this.sampleRate});

  General.fromJson(Map<String, dynamic> json) {
    colorDepth = json['colorDepth'];
    colorSpace = json['colorSpace'];
    name = json['name'];
    sampleRate = json['sampleRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorDepth'] = this.colorDepth;
    data['colorSpace'] = this.colorSpace;
    data['name'] = this.name;
    data['sampleRate'] = this.sampleRate;
    return data;
  }
}

class ImageQuality {
  Brightness brightness;
  int colorTemperature;
  Brightness contrast;
  int hue;
  int saturation;

  ImageQuality(
      {this.brightness,
      this.colorTemperature,
      this.contrast,
      this.hue,
      this.saturation});

  ImageQuality.fromJson(Map<String, dynamic> json) {
    brightness = json['brightness'] != null
        ? new Brightness.fromJson(json['brightness'])
        : null;
    colorTemperature = json['colorTemperature'];
    contrast = json['contrast'] != null
        ? new Brightness.fromJson(json['contrast'])
        : null;
    hue = json['hue'];
    saturation = json['saturation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brightness != null) {
      data['brightness'] = this.brightness.toJson();
    }
    data['colorTemperature'] = this.colorTemperature;
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

class Resolution {
  num height;
  num refresh;
  num width;
  int direction;

  Resolution({this.height, this.refresh, this.width, this.direction});

  Resolution.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    refresh = json['refresh'];
    width = json['width'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['refresh'] = this.refresh;
    data['width'] = this.width;
    data['direction'] = this.direction;
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

class Timing {
  Horizontal horizontal;
  int refreshRate;
  Horizontal vertical;

  Timing({this.horizontal, this.refreshRate, this.vertical});

  Timing.fromJson(Map<String, dynamic> json) {
    horizontal = json['horizontal'] != null
        ? new Horizontal.fromJson(json['horizontal'])
        : null;
    refreshRate = json['refreshRate'];
    vertical = json['vertical'] != null
        ? new Horizontal.fromJson(json['vertical'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.horizontal != null) {
      data['horizontal'] = this.horizontal.toJson();
    }
    data['refreshRate'] = this.refreshRate;
    if (this.vertical != null) {
      data['vertical'] = this.vertical.toJson();
    }
    return data;
  }
}

class Horizontal {
  int addrTime;
  int frontPorch;
  int sync;
  int syncPolarity;
  int totalTime;

  Horizontal(
      {this.addrTime,
      this.frontPorch,
      this.sync,
      this.syncPolarity,
      this.totalTime});

  Horizontal.fromJson(Map<String, dynamic> json) {
    addrTime = json['addrTime'];
    frontPorch = json['frontPorch'];
    sync = json['sync'];
    syncPolarity = json['syncPolarity'];
    totalTime = json['totalTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addrTime'] = this.addrTime;
    data['frontPorch'] = this.frontPorch;
    data['sync'] = this.sync;
    data['syncPolarity'] = this.syncPolarity;
    data['totalTime'] = this.totalTime;
    return data;
  }
}