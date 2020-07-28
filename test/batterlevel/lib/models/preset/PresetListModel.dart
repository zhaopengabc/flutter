import 'package:h_pad/models/preset/PresetGroupModel.dart';
// import 'package:h_pad/models/preset/PresetModel.dart';

class PresetList {
  List<Preset> presetList = new List();
  PresetList({this.presetList});

  factory PresetList.fromJson(List<dynamic> listJson) {
    listJson = listJson != null ? listJson : new List();
    List<Preset> presetList =  
        listJson.map((value) => new Preset.fromJson(value)).toList();  
    return PresetList(presetList: presetList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.presetList != null) {
      data['presetList'] = this.presetList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}