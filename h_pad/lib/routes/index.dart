/*
 * @Description: 存放所有路由页面类
 * @Author: benmo
 * @Date: 2020-01-13 11:36:53
 * @LastEditors: benmo
 */

import 'package:flutter/material.dart';
import 'package:h_pad/views/Edit/LayoutView.dart';
import 'package:h_pad/views/Init/InitView.dart';
import 'package:h_pad/views/Init/ManualDevice.dart';
import 'package:h_pad/views/Login/LoginView.dart';

class Routers {
  static Map routers(BuildContext context) {
    return <String, WidgetBuilder>{
      // 设备初始化页面
      'Init': (context) => new InitRouter(),
      // 手动输入设备列表
      'ManualDevice': (context) => new ManualDevice(),
      'Login': (context) => new LoginRoute(),
      'Edit': (context) => new EditView(),
    };
  }
}
