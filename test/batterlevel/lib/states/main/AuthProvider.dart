/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-07-01 19:42:49
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-07 17:11:56
 */
import 'package:flutter/material.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/states/common/ProfileChangeNotifier.dart';

class AuthProvider extends ProfileChangeNotifier {
  
  //剩余时间
  num _remainingTime = 7 * 24 * 60;
  num get remainingTime => _remainingTime;
  set remainingTime(num value){
    _remainingTime = value;
    notifyListeners();
  }
  //是否已授权
  // bool _hasAuthed;
  bool get hasAuthed => _remainingTime == GeneralConstant.HasAuthedCode ? true : false;
  // set hasAuthed(bool value){
  //   _hasAuthed = value;
  //   notifyListeners();
  // }
  //授权弹窗是否显示
  bool _isDialogShow;
  bool get isDialogShow => _isDialogShow;
  set isDialogShow(bool value){
    _isDialogShow = value;
    notifyListeners();
  }
  //显示的dialog类型：1：授权页面；0：提示页面; -1: 不显示页面
  int _tipCode = 1;
  int get tipCode => _tipCode;
  set tipCode(int value){
    _tipCode = value;
    notifyListeners();
  } 

  //是否显示复制粘贴工具栏
  bool _isCopyToolbarShow = false;
  bool get isCopyToolbarShow => _isCopyToolbarShow;
  set isCopyToolbarShow(bool value){
    _isCopyToolbarShow = value;
    notifyListeners();
  }
}
