class OutputMode {
  Mosaic mosaic;
  List<ScreenInterface> screenInterfaces = new List<ScreenInterface>();
  OutputSize size;

  OutputMode({this.mosaic, this.screenInterfaces, this.size});

  OutputMode.fromJson(Map<String, dynamic> json) {
    mosaic =
        json['mosaic'] != null ? new Mosaic.fromJson(json['mosaic']) : null;
    if (json['screenInterfaces'] != null) {
      // screenInterfaces = ;
      json['screenInterfaces'].forEach((v) {
        screenInterfaces.add(new ScreenInterface.fromJson(v));
      });
    }
    size = json['size'] != null ? new OutputSize.fromJson(json['size']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mosaic != null) {
      data['mosaic'] = this.mosaic.toJson();
    }
    if (this.screenInterfaces != null) {
      data['screenInterfaces'] =
          this.screenInterfaces.map((v) => v.toJson()).toList();
    }
    if (this.size != null) {
      data['size'] = this.size.toJson();
    }
    return data;
  }
}

class Mosaic {
  int column;
  int row;

  Mosaic({this.column, this.row});

  Mosaic.fromJson(Map<String, dynamic> json) {
    column = json['column'];
    row = json['row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['column'] = this.column;
    data['row'] = this.row;
    return data;
  }
}

class ScreenInterface {
  int connectCapacity;
  int cropx;
  int cropy;
  int dotpitch;
  int height;
  int interfaceId;
  int interfaceType;
  int isCardOnline;
  int modelId;
  int outputId;
  String outputName;
  int slotId;
  int width;
  int x;
  int y;

  ScreenInterface(
      {this.connectCapacity,
      this.cropx,
      this.cropy,
      this.dotpitch,
      this.height,
      this.interfaceId,
      this.interfaceType,
      this.isCardOnline,
      this.modelId,
      this.outputId,
      this.outputName,
      this.slotId,
      this.width,
      this.x,
      this.y});

  ScreenInterface.fromJson(Map<String, dynamic> json) {
    connectCapacity = json['connectCapacity'];
    cropx = json['cropx'];
    cropy = json['cropy'];
    dotpitch = json['dotpitch'];
    height = json['height'];
    interfaceId = json['interfaceId'];
    interfaceType = json['interfaceType'];
    isCardOnline = json['isCardOnline'];
    modelId = json['modelId'];
    outputId = json['outputId'];
    outputName = json['outputName'];
    slotId = json['slotId'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectCapacity'] = this.connectCapacity;
    data['cropx'] = this.cropx;
    data['cropy'] = this.cropy;
    data['dotpitch'] = this.dotpitch;
    data['height'] = this.height;
    data['interfaceId'] = this.interfaceId;
    data['interfaceType'] = this.interfaceType;
    data['isCardOnline'] = this.isCardOnline;
    data['modelId'] = this.modelId;
    data['outputId'] = this.outputId;
    data['outputName'] = this.outputName;
    data['slotId'] = this.slotId;
    data['width'] = this.width;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class OutputSize {
  int height;
  int width;
  int x;
  int y;

  OutputSize({this.height, this.width, this.x, this.y});

  OutputSize.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
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