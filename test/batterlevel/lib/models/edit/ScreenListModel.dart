/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-11 15:27:38
 */ 
import 'package:h_pad/models/screen/ScreenModel.dart';

class ScreenListInfoModel {
  List<ScreenModel> screenList = new List();
  ScreenListInfoModel({this.screenList});

  factory ScreenListInfoModel.fromJson(List<dynamic> listJson) {
    List<ScreenModel> screenList =  
        listJson.map((value) => new ScreenModel.fromJson(value)).toList();  
    return ScreenListInfoModel(screenList: screenList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.screenList != null) {
      data['screenList'] = this.screenList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

enum DragOrientation{
  left,
  right
}