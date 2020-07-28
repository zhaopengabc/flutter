import 'package:flutter/services.dart';
import 'dart:async';

class Exit {
   Exit._();
  static Future<void> pop({bool animated}) async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop',animated);
  }
}
