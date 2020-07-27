import 'dart:convert';

import 'package:flutter/services.dart';

class Toll {
  static void hideKeyboard({Function func}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide').whenComplete(() {
      Future.delayed(Duration(milliseconds: 50)).whenComplete(() {
        if (func == null) return;
        func();
      });
    });
  }

  static copy(dynamic data) {
    return json.decode(json.encode(data));
  }

  static computeSize(w, args) {
    double ratio = args[0] / args[1];
    if (ratio >= 1) {
      return {'w': w, 'h': w / ratio};
    } else {
      return {'w': w * ratio, 'h': w};
    }
  }

  static toFixed(double number, int num) {
    return double.parse(number.toStringAsFixed(num));
  }

  static listFind(List list, callBack) {
    var item;
    list.forEach((it) {
      if (callBack(it)) {
        item = it;
      }
    });
    return item;
  }
}
