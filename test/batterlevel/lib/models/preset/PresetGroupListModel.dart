import 'package:h_pad/models/preset/PresetGroupModel.dart';

class PresetGroupList {
  List<PresetGroup> presetGroupList = new List();
  PresetGroupList({this.presetGroupList});

  factory PresetGroupList.fromJson(List<dynamic> listJson) {
    listJson = listJson != null ? listJson : new List();
    List<PresetGroup> presetGroupList =  
        listJson.map((value) => new PresetGroup.fromJson(value)).toList();  
    return PresetGroupList(presetGroupList: presetGroupList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.presetGroupList != null) {
      data['presetGroupList'] = this.presetGroupList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}