import 'package:flutter/material.dart';
import 'package:h_pad/models/device/DeviceDetail.dart';
class DeviceDetailProvider with ChangeNotifier {
  //屏幕列表
  DeviceDetail _deviceDetail;
  DeviceDetail get deviceDetail => _deviceDetail;
  set deviceDetail(DeviceDetail value) {
    if (value != null) {
      _deviceDetail = value;
      notifyListeners();
    }
  }
}