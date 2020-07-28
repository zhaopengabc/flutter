import 'package:h_pad/models/screen/ScreenLayersModel.dart';

class InputModel {
  int inputId;
  int deviceId;
  int slotId;
  int interfaceId;
  int interfaceType;
  int iSignal;
  int online;
  int isEDIDSetting;
  InputGeneral general;
  InputResolution resolution;
  InputTiming timing;
  List<InputCrop> crops = new List();

  InputModel(
      {this.inputId,
      this.deviceId,
      this.slotId,
      this.interfaceId,
      this.interfaceType,
      this.iSignal,
      this.online,
      this.isEDIDSetting,
      this.general,
      this.resolution,
      this.timing,
      this.crops});

  InputModel.fromJson(Map<String, dynamic> json) {
    inputId = json['inputId'];
    deviceId = json['deviceId'];
    slotId = json['slotId'];
    interfaceId = json['interfaceId'];
    interfaceType = json['interfaceType'];
    iSignal = json['iSignal'];
    online = json['online'];
    isEDIDSetting = json['isEDIDSetting'];
    general =
        json['general'] != null ? new InputGeneral.fromJson(json['general']) : null;
    resolution = json['resolution'] != null
        ? new InputResolution.fromJson(json['resolution'])
        : null;
    timing =
        json['timing'] != null ? new InputTiming.fromJson(json['timing']) : null;
    if (json['crops'] != null) {
      // crops = new List<InputCrops>();
      json['crops'].forEach((v) {
        crops.add(new InputCrop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inputId'] = this.inputId;
    data['deviceId'] = this.deviceId;
    data['slotId'] = this.slotId;
    data['interfaceId'] = this.interfaceId;
    data['interfaceType'] = this.interfaceType;
    data['iSignal'] = this.iSignal;
    data['isEDIDSetting'] = this.isEDIDSetting;
    if (this.general != null) {
      data['general'] = this.general.toJson();
    }
    if (this.resolution != null) {
      data['resolution'] = this.resolution.toJson();
    }
    if (this.timing != null) {
      data['timing'] = this.timing.toJson();
    }
    if (this.crops != null) {
      data['crops'] = this.crops.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InputGeneral {
  String name;
  int colorDepth;
  int colorSpace;
  int sampleRate;
  int connectCapacity;
  int hDCPEncryted;

  InputGeneral(
      {this.name,
      this.colorDepth,
      this.colorSpace,
      this.sampleRate,
      this.connectCapacity,
      this.hDCPEncryted});

  InputGeneral.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    colorDepth = json['colorDepth'];
    colorSpace = json['colorSpace'];
    sampleRate = json['sampleRate'];
    connectCapacity = json['connectCapacity'];
    hDCPEncryted = json['HDCPEncryted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['colorDepth'] = this.colorDepth;
    data['colorSpace'] = this.colorSpace;
    data['sampleRate'] = this.sampleRate;
    data['connectCapacity'] = this.connectCapacity;
    data['HDCPEncryted'] = this.hDCPEncryted;
    return data;
  }
}

class InputResolution {
  int width;
  int height;
  num refresh;
  int isInterlace;

  InputResolution({this.width, this.height, this.refresh, this.isInterlace});

  InputResolution.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    refresh = json['refresh'];
    isInterlace = json['isInterlace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['refresh'] = this.refresh;
    data['isInterlace'] = this.isInterlace;
    return data;
  }
}

class InputTiming {
  num refreshRate;
  InputHorizontal horizontal;
  InputHorizontal vertical;

  InputTiming({this.refreshRate, this.horizontal, this.vertical});

  InputTiming.fromJson(Map<String, dynamic> json) {
    refreshRate = json['refreshRate'];
    horizontal = json['horizontal'] != null
        ? new InputHorizontal.fromJson(json['horizontal'])
        : null;
    vertical = json['vertical'] != null
        ? new InputHorizontal.fromJson(json['vertical'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refreshRate'] = this.refreshRate;
    if (this.horizontal != null) {
      data['horizontal'] = this.horizontal.toJson();
    }
    if (this.vertical != null) {
      data['vertical'] = this.vertical.toJson();
    }
    return data;
  }
}

class InputHorizontal {
  int addrTime;
  int frontPorch;
  int sync;
  int syncPolarity;
  int totalTime;

  InputHorizontal(
      {this.addrTime,
      this.frontPorch,
      this.sync,
      this.syncPolarity,
      this.totalTime});

  InputHorizontal.fromJson(Map<String, dynamic> json) {
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

class InputCrop {
  int cropId;
  String name;
  int width;
  int heigth;
  int x;
  int y;

  InputCrop({this.cropId, this.name, this.width, this.heigth, this.x, this.y});

  InputCrop.fromJson(Map<String, dynamic> json) {
    cropId = json['cropId'];
    name = json['name'];
    width = json['width'];
    heigth = json['height'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cropId'] = this.cropId;
    data['name'] = this.name;
    data['width'] = this.width;
    data['heigth'] = this.heigth;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
