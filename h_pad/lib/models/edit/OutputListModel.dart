/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-02 18:48:00
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-02 18:51:09
 */ 
import 'package:h_pad/models/output/OutputModel.dart';

class OutputListInfoModel {
  List<OutputModel> outputList = new List();
  OutputListInfoModel({this.outputList});

  factory OutputListInfoModel.fromJson(List<dynamic> listJson) {
    List<OutputModel> outputList =  
        listJson.map((value) => new OutputModel.fromJson(value)).toList();  
    return OutputListInfoModel(outputList: outputList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.outputList != null) {
      data['inputList'] = this.outputList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}