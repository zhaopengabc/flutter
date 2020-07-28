class NomarkModeInfo {
  String bkg;
  int deviceId;
  String icon;
  String logo;
  int nomarkMode;
  List<CustomList> customList;

  NomarkModeInfo(
      {this.bkg,
      this.deviceId,
      this.icon,
      this.logo,
      this.nomarkMode,
      this.customList});

  NomarkModeInfo.fromJson(Map<String, dynamic> json) {
    bkg = json['bkg'];
    deviceId = json['deviceId'];
    icon = json['icon'];
    logo = json['logo'];
    nomarkMode = json['nomarkMode'];
    if (json['customList'] != null) {
      customList = new List<CustomList>();
      json['customList'].forEach((v) {
        customList.add(new CustomList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bkg'] = this.bkg;
    data['deviceId'] = this.deviceId;
    data['icon'] = this.icon;
    data['logo'] = this.logo;
    data['nomarkMode'] = this.nomarkMode;
    if (this.customList != null) {
      data['customList'] = this.customList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomList {
  int order;
  String key;
  String value;

  CustomList({this.order, this.key, this.value});

  CustomList.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}