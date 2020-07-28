/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-27 09:52:08
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-02 17:44:55
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// 存储用于播放视频的图片帧数据.
// _image会被高频率的刷新(约15次/秒)
class VideoProvider with ChangeNotifier {
  ui.Image _image;

  set image(ui.Image value) {
    _image = value;
    notifyListeners();
  }

  ui.Image get image => _image;
}
