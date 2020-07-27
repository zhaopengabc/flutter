/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-22 11:33:13
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-22 11:56:17
 */ 
import 'package:flutter/material.dart';

class MenualDeviceProvider with ChangeNotifier {
  //设备IP连接按钮状态, true-可点击，false-不可点击
  bool _isConnectDisabled = true; 
  bool get isConnectDisabled => _isConnectDisabled;
  set isConnectDisabled(bool value){
    _isConnectDisabled = value;
    notifyListeners();
  }
}