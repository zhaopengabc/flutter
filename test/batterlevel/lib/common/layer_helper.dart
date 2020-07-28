import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h_pad/models/screen/OutPutModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:h_pad/states/edit/GestureTemplate.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:provider/provider.dart';

class PhyicalAndLogicalConverter {
  static getLogicalWidth(double realWidth, BuildContext context) {
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
  }

  static getLogicalHeight() {}
  static getLogicalOffsetLeft() {
    
  }
  //屏幕尺寸
  static getLogicalOffsetTop(double pRealX, BuildContext context) {

  }

  //下发的屏幕宽度
  static getRealWidth(double pScreenWidth, BuildContext context) {
    ScreenModel currentScreen = Provider.of<EditProvider>(context, listen: false).currentScreen;
    //屏幕与物理屏幕比例
    double radioW = Provider.of<RenderBoxProvider>(context, listen: false).getRatioW(currentScreen?.outputMode?.size?.width);
    double w = pScreenWidth / radioW;
    return w;
  }

  //下发的屏幕高度
  static getRealHeight(double pScreenHeight, BuildContext context) {
    ScreenModel currentScreen = Provider.of<EditProvider>(context, listen: false).currentScreen;
    //屏幕与物理屏幕比例
    double radioH = Provider.of<RenderBoxProvider>(context, listen: false).getRatioW(currentScreen?.outputMode?.size?.height);
    double h = pScreenHeight * radioH;
    return h;
  }

  //下发屏幕的x值
  static getRealOffsetLeft(num pScreenX, num outputOffsetX, num radioW) {
    int x = (pScreenX / radioW + outputOffsetX).round();
    return x;
  }

  //下发的屏幕y值
  static getRealOffsetTop(double pScreenY, num outputOffsetY, num radioH) {
    int y = (pScreenY / radioH + outputOffsetY).round();
    return y;
  }
}

class ListOperation{
  
  // 根据z序将图层列表排序
  static sortLayerByZorder(List<ScreenLayer> layerListData) {
    if (layerListData == null) return null;
    for (var i = 1; i < layerListData.length; i++) {
      if (layerListData[i].general.zorder <
          layerListData[i - 1].general.zorder) {
        var temp = layerListData[i];
        var j = i - 1;
        layerListData[i] = layerListData[j];
        while (
            j >= 0 && temp.general.zorder < layerListData[j].general.zorder) {
          layerListData[j + 1] = layerListData[j];
          j--;
        }
        layerListData[j + 1] = temp;
      }
    }
    return layerListData;
  }
}

class ColorGenerator{
  static List<Color> colors = [Colors.teal[200], Colors.blue[200], Colors.green[300], Colors.purple[300], Colors.pink[100], Colors.blueAccent[300]];
  static Color randomGenerator() {
    return colors[new Random().nextInt(2)];
  }
}