/*
 * @Description: 
 * @Author: wzh
 * @Date: 2020-06-18 16:21:08
 * @LastEditors: wzh
 * @LastEditTime: 2020-06-18 17:51:46
 */ 
import 'package:flutter/material.dart';
import  'dart:io';

class DeviceListProvider with ChangeNotifier {
  bool lock = false;
  int count = 0;
  List<Map> _deviceLists = new List();
  int _displayState = 3; //1：设备列表；2：搜索中；3.搜索失败
  int get displayState => _displayState;
  set displayState(int value){
    _displayState = value;
    notifyListeners();
  }
 forceUpdate(){
   notifyListeners();
 }
  set addDevice(Map params) {
    try {
      while (lock) {
        sleep(Duration(milliseconds: 50));
        if (count > 10) {
          break;
        }
        count++;
      }
    } catch(e) {
      lock = false;
      count = 0;
    }


    if (!lock) {
      try {
        lock = true;
        if (params['status'] == 1 || params['status'] == '1') { // 正常设备
          if (!_deviceLists.any((obj) => obj['data']['sn'] == params['data']['sn'] && obj['ip'] == params['ip'])) {
            _deviceLists.add(params);
            // print('刷新设备列表22222=========================$_deviceLists');
            notifyListeners();
          }else{
            notifyListeners();
          }
        }
      } catch(e) {
        print(e);
      } finally {
        lock = false;
        count = 0;
      }
    }
  }

  // 获取设备列表
  get getDeviceLists => _deviceLists;

  //清空设备列表
  void clearDevice() {
    // print('清空设备');
    // _deviceLists.clear();
    _deviceLists = List();
    // print('清空后的数据列表=========${_deviceLists.length}');
    notifyListeners();
  }
}
