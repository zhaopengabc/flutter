/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-08 16:20:02
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-19 18:25:38
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';

class LayerTipProvider with ChangeNotifier {
  List<LayerTip> _layerTips = new List();
  List<LayerTip> get layerTips => _layerTips;
  setCustomerLayerTips(LayerTip value){
    if(value != null){
      if(_layerTips.length>0 && value.screenId != _layerTips[0].screenId) {
        _layerTips.clear();
      }
      LayerTip find = layerTips.firstWhere((p)=> p.screenId == value.screenId && p.layerId == value.layerId, orElse: () => null);
      if(find != null){
        if(find.tipState == true && find.timer!=null){
          find.timer.cancel();
          find.user = value.user;
          find.timer = new Timer(new Duration(seconds: 2), () {
            find.tipState = false;
            find.timer = null;
            notifyListeners();
          });
        }else{
          find.tipState = true;
          find.user = value.user;
          find.timer = new Timer(new Duration(seconds: 2), () {
            find.tipState = false;
            find.timer = null;
            notifyListeners();
          });
        }
      }else{
        value.tipState = true;
        value.timer = new Timer(new Duration(seconds: 2), () {
            value.tipState = false;
            value.timer = null;
            notifyListeners();
          });
        _layerTips.add(value);
      }
    }
  }
}
