/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-15 18:06:49
 */ 
import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';

class RenderBoxProvider with ChangeNotifier {
  // 屏幕区RendenBox
  Offset _screenRenderBoxOffset;
  Offset get screenRenderBoxOffset => _screenRenderBoxOffset;
  set screenRenderBoxOffset(Offset value) {
    _screenRenderBoxOffset = value;
    notifyListeners();
  }

  //屏幕区大小
  Size _screenRenderBoxSize;
  Size get screenRenderBoxSize => _screenRenderBoxSize;
  set screenRenderBoxSize(Size value) {
    this._screenRenderBoxSize = value;
    // notifyListeners();
  }

// 编辑分屏操作区RendenBox
  Offset _splitRenderBoxOffset;
  Offset get splitRenderBoxOffset => _splitRenderBoxOffset;
  set splitRenderBoxOffset(Offset value) {
    this._splitRenderBoxOffset = value;
    // notifyListeners();
  }

  Size _splitRenderBoxSize;
  Size get splitRenderBoxSize => _splitRenderBoxSize;
  set splitRenderBoxSize(Size value) {
    this._screenRenderBoxSize = value;
    // notifyListeners();
  }

  // 编辑区RendenBox
  Offset _editRenderBoxOffset;
  Offset get editRenderBoxOffset => _editRenderBoxOffset;
  set editRenderBoxOffset(Offset value) {
    this._editRenderBoxOffset = value;
    // notifyListeners();
  }

//屏幕宽/物理宽
  double getRatioW(int realWidth) {
    if (realWidth == null || _screenRenderBoxSize == null) return 1;
    return _screenRenderBoxSize.width / realWidth;
  }

//屏幕高/物理高
  double getRatioH(int realHeight) {
    if (realHeight == null || _screenRenderBoxSize == null) return 1;
    return _screenRenderBoxSize.height / realHeight;
  }

//屏幕左上角距离编辑区左上角的offsetLeft
  double get screenFromEditLeft {
    if (_screenRenderBoxOffset == null || _editRenderBoxOffset == null)
      return 0;
    return _screenRenderBoxOffset.dx - _editRenderBoxOffset.dx;
  }

//屏幕左上角距离编辑区左上角的offsetTop
  double get screenFromEditTop {
    if (_screenRenderBoxOffset == null || _editRenderBoxOffset == null)
      return 0;
    return _screenRenderBoxOffset.dy - _editRenderBoxOffset.dy;
  }

// 输出卡的位置信息
  List<Position> _outputCardPositionList;
  List<Position> get outputCardPositionList => _outputCardPositionList;
  set outputCardPositionList(List<Position> value) {
    if (value != _outputCardPositionList) {
      _outputCardPositionList = value;
    }
  }

// 图层的位置信息
  List<Position> _layerPositionList;
  List<Position> get layerPositionList => _layerPositionList;
  set layerPositionList(List<Position> value) {
    if (value != _layerPositionList) {
      _layerPositionList = value;
    }
  }
}
