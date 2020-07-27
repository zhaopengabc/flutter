/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-17 15:42:36
 */ 
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_pad/common/layer_justification.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';

//相对于屏幕的坐标
class LayerPosition {
  double left;
  double top;
  double width;
  double height;
  LayerPosition({this.left, this.top, this.width, this.height});
}
//用户自定义图层信息，包括图层位置信息与图层原有信息
class CustomerLayer{
  LayerPosition layerPosition;
  ScreenLayer screenLayer;
  bool hasSource;
  bool hasSignal;
  Color noSignalColor;
  Color noSourceColor;
  InputCrop inputCrop;
  InputResolution inputResolution;
  CustomerLayer({this.screenLayer, this.layerPosition, this.hasSource, this.hasSignal, this.noSignalColor, this.noSourceColor, this.inputCrop, this.inputResolution});
}

//用户正在操作某图层提示信息类
class LayerTip{
  int screenId;
  int layerId;
  String user;
  bool tipState;
  Timer timer;
  LayerTip({this.screenId, this.layerId, this.user, this.tipState});
}

//吸附相关位置信息类（输出卡、图层）
class Position{
  int layerId;
  double left;
  double top;
  double width;
  double height;
  Position({this.layerId, this.left, this.top, this.width, this.height});
}

//图层吸附返回位置信息类
class AdsorbedPosition{
  double horizontal;
  double vertical;
  MoveDirection moveDirection;
  AdsorbedPosition({this.horizontal, this.vertical, this.moveDirection});
}

class Point{
  double offsetX;
  double offsetY;
  Point({this.offsetX, this.offsetY});
}