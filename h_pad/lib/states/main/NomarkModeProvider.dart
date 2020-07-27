import 'package:flutter/cupertino.dart';
import 'package:h_pad/models/main/NomarkModeModle.dart';

class NomarkModeProvider with ChangeNotifier {
  NomarkModeInfo _nomarkModeInfo;
  NomarkModeInfo get nomarkModeInfo => _nomarkModeInfo;
  set nomarkModeInfo(NomarkModeInfo value) {
    if (_nomarkModeInfo != value) {
      _nomarkModeInfo = value;
      notifyListeners();
    }
  }

  // //中性模式状态
  // // 0：默认商标；
  // // 1：隐藏商标；
  // // 2：定制商标

  // int _nomarkMode;
  // int get nomarkMode => _nomarkMode;
  // set nomarkMode(int value) {
  //   if (_nomarkMode != value) {
  //     _nomarkMode = value;
  //     notifyListeners();
  //   }
  // }

  // //背景色图片URL
  // String _bkg;
  // String get bkg => _bkg;
  // set bkg(String value) {
  //   if (_bkg != value) {
  //     _bkg = value;
  //     notifyListeners();
  //   }
  // }

  // //背景色图片URL
  // String _icon;
  // String get icon => _icon;
  // set icon(String value) {
  //   if (_icon != value) {
  //     _icon = value;
  //     notifyListeners();
  //   }
  // }

  // //背景色图片URL
  // String _logo;
  // String get logo => _logo;
  // set logo(String value) {
  //   if (_logo != value) {
  //     _logo = value;
  //     notifyListeners();
  //   }
  // }


}
