/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-19 18:31:48
 */ 

import 'package:flutter/material.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';

class LayerProvider with ChangeNotifier {
  //图层列表
  List<CustomerLayer> _customerLayers;
  List<CustomerLayer> get customerLayers => _customerLayers;
  set customerLayers(List<CustomerLayer> value) {
    _customerLayers = value;
    notifyListeners();
  }
  //获取图层位置信息
  LayerPosition getLayerPosition(int layerId){
    LayerPosition layerPosition ;
    int index = _customerLayers.indexWhere((p) => p.screenLayer.layerId == layerId);
    if(index != -1){
      layerPosition = _customerLayers[index].layerPosition;
    }
    return layerPosition;
  }
  //更新图层位置信息
  bool updateCustomerLayerPosition(int layerId, num left, num top, num width, num height){
    bool isSucc = true;
    int index = _customerLayers.indexWhere((p) => p.screenLayer.layerId == layerId);
    if(index != -1){
      _customerLayers[index].layerPosition.left = left;
      _customerLayers[index].layerPosition.top = top;
      _customerLayers[index].layerPosition.width = width;
      _customerLayers[index].layerPosition.height = height;
      notifyListeners();
    }else{
      isSucc = false;
    }
    return isSucc;
  }
  //根据图层id,返回图层
  CustomerLayer getLayer(int layerId){
    CustomerLayer customerLayer;
    int index = _customerLayers.indexWhere((p) => p.screenLayer.layerId == layerId);
    if(index != -1){
      customerLayer = _customerLayers[index];
    }
    return customerLayer;
  }

  void forceUpdate() {
    notifyListeners();
  }


  // //图层offsetTop
  // double _top = 0;
  // double get top => _top;
  // set top(double value) {
  //   _top = value;
  //   notifyListeners();
  // }
  // //图层offSetLeft
  // double _left = 0;
  // double get left => _left;
  // set left(double value) {
  //   _left = value;
  //   notifyListeners();
  // }
  // //图层宽
  // double _width = 0;
  // double get width => _width;
  // set width(double value) {
  //   _width = value;
  //   notifyListeners();
  // }
  // //图层高
  // double _height = 0;
  // double get height => _height;
  // set height(double value) {
  //   _height = value;
  //   notifyListeners();
  // }
}