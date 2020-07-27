/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-02 18:55:04
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-02 19:02:15
 */ 
import 'package:flutter/material.dart';
import 'package:h_pad/models/output/OutputModel.dart';

class OutputProvider with ChangeNotifier {
  //输入列表
  List<OutputModel> _outputList = new List();
  List<OutputModel> get outputList => _outputList;
  set outputList(List<OutputModel> pList) {
    if(_outputList != pList){
      _outputList = pList;//pList.where((p)=>p.online == 1).toList();
      notifyListeners();
    }
  }
}