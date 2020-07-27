///
/// loading
/// 使用 调用 showLoadingDialog(context)
/// 关闭  Navigator.of(context).pop();
///

import 'package:flutter/material.dart';
import 'package:h_pad/style/index.dart';

showLoadingDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColorMap.app_main, //ColorMap.app_main,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(
                "loading...",
                style: TextStyle(
                  color: ColorMap.text_normal,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

///  无论如何初始化，取到的都是同一个对象
///  LoadingDialog loadingDialog = new LoadingDialog(context);
///  LoadingDialog loadingDialog = LoadingDialog(context).instance;
/// 关闭
/// loadingDialog.dispose();
/// 查询状态 在类上查询 fasle 关闭 true 为打开状态
/// LoadingDialog.state

class LoadingDialog {
  // 工厂模式
  factory LoadingDialog(context) => _getInstance(context);
  static LoadingDialog get instance => _getInstance(_context);
  static LoadingDialog _instance;
  static BuildContext _context;
  static bool state = false;

  LoadingDialog._internal(context) {
    // 初始化
    if (context != null) {
      _context = context;
    }
    state = true;
    // 初始化
    showDialog(
      context: _context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorMap.app_main, //ColorMap.app_main,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(
                  "loading...",
                  style: TextStyle(
                    color: ColorMap.text_normal,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  static LoadingDialog _getInstance(context) {
    if (_instance == null) {
      _instance = new LoadingDialog._internal(context);
    }
    return _instance;
  }

  // 关闭
  void dispose() {
    if (state || _instance != null) {
      Navigator.of(_context).pop();
      _instance = null;
      state = false;
    }
  }
}
