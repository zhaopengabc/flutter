/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-22 18:58:39
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-22 19:07:18
 */ 
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  //用户名列表是否展开显示
  bool _expand = false; 
  bool get expand => _expand;
  set expand(bool value){
    _expand = value;
    notifyListeners();
  }

  //登录按钮是否可用
  bool _loginBtnDisabled = false; 
  bool get loginBtnDisabled => _loginBtnDisabled;
  set loginBtnDisabled(bool value){
    _loginBtnDisabled = value;
    notifyListeners();
  }
}