import 'package:h_pad/models/edit/ScreenListModel.dart';

class ScreenLayer {
  int deviceId;
  LayerGeneral general;
  int layerId;
  Lock lock;
  int screenId;
  LayerSource source;
  Window window;

  ScreenLayer(
      {this.deviceId,
      this.general,
      this.layerId,
      this.lock,
      this.screenId,
      this.source,
      this.window});

  ScreenLayer.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    general =
        json['general'] != null ? new LayerGeneral.fromJson(json['general']) : null;
    layerId = json['layerId'];
    lock = json['lock'] != null ? new Lock.fromJson(json['lock']) : null;
    screenId = json['screenId'];
    source =
        json['source'] != null ? new LayerSource.fromJson(json['source']) : null;
    window = json['window'] != null ? new Window.fromJson(json['window']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    if (this.general != null) {
      data['general'] = this.general.toJson();
    }
    data['layerId'] = this.layerId;
    if (this.lock != null) {
      data['lock'] = this.lock.toJson();
    }
    data['screenId'] = this.screenId;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    if (this.window != null) {
      data['window'] = this.window.toJson();
    }
    return data;
  }
}


class LayerGeneral {
  int flipType;
  bool isBackground;
  bool isFreeze;
  int layerId;
  String name;
  int sizeType;
  int type;
  int zorder;

  LayerGeneral(
      {this.flipType,
      this.isBackground,
      this.isFreeze,
      this.layerId,
      this.name,
      this.sizeType,
      this.type,
      this.zorder});

  LayerGeneral.fromJson(Map<String, dynamic> json) {
    flipType = json['flipType'];
    isBackground = json['isBackground'];
    isFreeze = json['isFreeze'];
    layerId = json['layerId'];
    name = json['name'];
    sizeType = json['sizeType'];
    type = json['type'];
    zorder = json['zorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flipType'] = this.flipType;
    data['isBackground'] = this.isBackground;
    data['isFreeze'] = this.isFreeze;
    data['layerId'] = this.layerId;
    data['name'] = this.name;
    data['sizeType'] = this.sizeType;
    data['type'] = this.type;
    data['zorder'] = this.zorder;
    return data;
  }
}

class Lock {
  int lock;

  Lock({this.lock});

  Lock.fromJson(Map<String, dynamic> json) {
    lock = json['lock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lock'] = this.lock;
    return data;
  }
}

class LayerSource {
  int connectCapacity;
  int cropId;
  int inputId;
  int interfaceType;
  int modelId;
  String name;
  int sourceType;

  LayerSource(
      {this.connectCapacity,
      this.cropId,
      this.inputId,
      this.interfaceType,
      this.modelId,
      this.name,
      this.sourceType});

  LayerSource.fromJson(Map<String, dynamic> json) {
    connectCapacity = json['connectCapacity'];
    cropId = json['cropId'];
    inputId = json['inputId'];
    interfaceType = json['interfaceType'];
    modelId = json['modelId'];
    name = json['name'];
    sourceType = json['sourceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectCapacity'] = this.connectCapacity;
    data['cropId'] = this.cropId;
    data['inputId'] = this.inputId;
    data['interfaceType'] = this.interfaceType;
    data['modelId'] = this.modelId;
    data['name'] = this.name;
    data['sourceType'] = this.sourceType;
    return data;
  }
}

class Window {
  num height;
  num width;
  num x;
  num y;
  int screenId;
  int layerId;

  Window({this.height, this.width, this.x, this.y, this.screenId, this.layerId});

  Window.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
    screenId = json['screenId'];
    layerId = json['layerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
