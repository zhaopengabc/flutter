// class Preset {
//   int deviceId;
//   List<Layers> layers = new List<Layers>();
//   String name;
//   int presetId;
//   int screenId;

//   Preset({this.deviceId, this.layers, this.name, this.presetId, this.screenId});

//   Preset.fromJson(Map<String, dynamic> json) {
//     deviceId = json['deviceId'];
//     if (json['layers'] != null) {
//       layers = new List<Layers>();
//       json['layers'].forEach((v) {
//         layers.add(new Layers.fromJson(v));
//       });
//     }
//     name = json['name'];
//     presetId = json['presetId'];
//     screenId = json['screenId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['deviceId'] = this.deviceId;
//     if (this.layers != null) {
//       data['layers'] = this.layers.map((v) => v.toJson()).toList();
//     }
//     data['name'] = this.name;
//     data['presetId'] = this.presetId;
//     data['screenId'] = this.screenId;
//     return data;
//   }
// }

// class Layers {
//   General general;
//   Source source;
//   Window window;

//   Layers({this.general, this.source, this.window});

//   Layers.fromJson(Map<String, dynamic> json) {                                                  
//     general =
//         json['general'] != null ? new General.fromJson(json['general']) : null;
//     source =
//         json['source'] != null ? new Source.fromJson(json['source']) : null;
//     window =
//         json['window'] != null ? new Window.fromJson(json['window']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.general != null) {
//       data['general'] = this.general.toJson();
//     }
//     if (this.source != null) {
//       data['source'] = this.source.toJson();
//     }
//     if (this.window != null) {
//       data['window'] = this.window.toJson();
//     }
//     return data;
//   }
// }

// class General {
//   int flipType;
//   bool isBackground;
//   bool isFreeze;
//   int layerId;
//   String name;
//   int sizeType;
//   int type;
//   int zorder;

//   General(
//       {this.flipType,
//       this.isBackground,
//       this.isFreeze,
//       this.layerId,
//       this.name,
//       this.sizeType,
//       this.type,
//       this.zorder});

//   General.fromJson(Map<String, dynamic> json) {
//     flipType = json['flipType'];
//     isBackground = json['isBackground'];
//     isFreeze = json['isFreeze'];
//     layerId = json['layerId'];
//     name = json['name'];
//     sizeType = json['sizeType'];
//     type = json['type'];
//     zorder = json['zorder'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['flipType'] = this.flipType;
//     data['isBackground'] = this.isBackground;
//     data['isFreeze'] = this.isFreeze;
//     data['layerId'] = this.layerId;
//     data['name'] = this.name;
//     data['sizeType'] = this.sizeType;
//     data['type'] = this.type;
//     data['zorder'] = this.zorder;
//     return data;
//   }
// }

// class Source {
//   int connectCapacity;
//   int cropId;
//   int inputId;
//   int interfaceType;
//   int modelId;
//   String name;
//   int sourceType;

//   Source(
//       {this.connectCapacity,
//       this.cropId,
//       this.inputId,
//       this.interfaceType,
//       this.modelId,
//       this.name,
//       this.sourceType});

//   Source.fromJson(Map<String, dynamic> json) {
//     connectCapacity = json['connectCapacity'];
//     cropId = json['cropId'];
//     inputId = json['inputId'];
//     interfaceType = json['interfaceType'];
//     modelId = json['modelId'];
//     name = json['name'];
//     sourceType = json['sourceType'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['connectCapacity'] = this.connectCapacity;
//     data['cropId'] = this.cropId;
//     data['inputId'] = this.inputId;
//     data['interfaceType'] = this.interfaceType;
//     data['modelId'] = this.modelId;
//     data['name'] = this.name;
//     data['sourceType'] = this.sourceType;
//     return data;
//   }
// }

// class Window {
//   int height;
//   int width;
//   int x;
//   int y;

//   Window({this.height, this.width, this.x, this.y});

//   Window.fromJson(Map<String, dynamic> json) {
//     height = json['height'];
//     width = json['width'];
//     x = json['x'];
//     y = json['y'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['height'] = this.height;
//     data['width'] = this.width;
//     data['x'] = this.x;
//     data['y'] = this.y;
//     return data;
//   }
// }