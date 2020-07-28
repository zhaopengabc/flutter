import 'package:flutter/material.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';


class EditProvider with ChangeNotifier {
  //屏幕列表
  List<ScreenModel> _screenList = new List();
  List<ScreenModel> get screenList => _screenList;
  set screenList(List<ScreenModel> pList) {
    if (_screenList != pList) {
      _screenList = pList;
      if (_currentScreenId == -1 && _screenList.length > 0) {
        currentScreenId = _screenList[0].screenId;
      } else if(_screenList.length == 0){
        _currentScreenId = -1;
      }
      notifyListeners();
    }
  }

  //当前显示屏幕id
  int _currentScreenId = -1;
  int get currentScreenId => _currentScreenId;
  set currentScreenId(int value) {
    if(value != null && _currentScreenId != value){
      _currentScreenId = value;
      notifyListeners();
    }
  }

  //选中图层id
  int _selectedLayerId = -1;
  int get selectedLayerId => _selectedLayerId;
  set selectedLayerId(int value) {
    _selectedLayerId = value;
    notifyListeners();
  }

  //当前切源图层id
  int _flickerLayerId = -1;
  int get flickerLayerId => _flickerLayerId;
  set flickerLayerId(int value) {
    _flickerLayerId = value;
    notifyListeners();
  }

  //当前显示屏幕
  // ScreenModel _currentScreen;
  ScreenModel get currentScreen {
    int index = _screenList.indexWhere((p) => p.screenId == _currentScreenId);
    return index != -1 ? _screenList[index] : null;
  }

  //当前屏幕的宽度
  double getCurrentScreenWidth(screenWidthBlank, screenHeightBlank) {
    if(currentScreenRealWidth==null || currentScreenRealHeight==null) return null;
    var screenWidth;
    var screenHeight;
    if (currentScreenRealWidth > currentScreenRealHeight) {
        screenWidth = (LayoutConstant.UILayoutWidth -
                LayoutConstant.PresetListWidth -
                LayoutConstant.SplitScrernWidth -
                30 * 2)
            .toDouble();
        screenHeight = currentScreenRealHeight / currentScreenRealWidth * screenWidth;
        if (screenHeight > screenHeightBlank) {
          // 处理高超出空白区域的情况
          screenHeight = screenHeightBlank;
          screenWidth = currentScreenRealWidth / currentScreenRealHeight * screenHeight;
        }
      } else {
        screenHeight = (LayoutConstant.UILayoutHeight -
                LayoutConstant.HeadHeight -
                LayoutConstant.InputListHeight -
                LayoutConstant.ActionBtnHeight -
                30 * 2)
            .toDouble();
        screenWidth = currentScreenRealWidth / currentScreenRealHeight * screenHeight;
        if (screenWidth > screenWidthBlank) {
          screenWidth = screenWidthBlank;
          screenHeight = currentScreenRealHeight / currentScreenRealWidth * screenWidth;
        }
      }
      _currentScreenScale = screenWidth / currentScreenRealWidth;
      return screenWidth;
  }
  //当前屏幕的高度
  double getCurrentScreenHeight(screenWidthBlank, screenHeightBlank) {
    if(currentScreenRealWidth==null || currentScreenRealHeight==null) return null;
    var screenWidth;
    var screenHeight;
    if (currentScreenRealWidth > currentScreenRealHeight) {
        screenWidth = (LayoutConstant.UILayoutWidth -
                LayoutConstant.PresetListWidth -
                LayoutConstant.SplitScrernWidth -
                30 * 2)
            .toDouble();
        screenHeight = currentScreenRealHeight / currentScreenRealWidth * screenWidth;
        if (screenHeight > screenHeightBlank) {
          // 处理高超出空白区域的情况
          screenHeight = screenHeightBlank;
          screenWidth = currentScreenRealWidth / currentScreenRealHeight * screenHeight;
        }
      } else {
        screenHeight = (LayoutConstant.UILayoutHeight -
                LayoutConstant.HeadHeight -
                LayoutConstant.InputListHeight -
                LayoutConstant.ActionBtnHeight -
                30 * 2)
            .toDouble();
        screenWidth = currentScreenRealWidth / currentScreenRealHeight * screenHeight;
        if (screenWidth > screenWidthBlank) {
          screenWidth = screenWidthBlank;
          screenHeight = currentScreenRealHeight / currentScreenRealWidth * screenWidth;
        }
      }
      _currentScreenScale = screenWidth / currentScreenRealWidth;
      return screenHeight;
  }
  //当前屏幕尺寸与实际尺寸比
  double _currentScreenScale;
  double get currentScreenScale => _currentScreenScale;

  //当前屏幕的真实宽度
  int get currentScreenRealWidth{
    return currentScreen?.outputMode?.size?.width;
  }

  //当前屏幕的真实高度
  int get currentScreenRealHeight{
    return currentScreen?.outputMode?.size?.height;
  }

  //当前屏幕的真实x
  int get currentScreenRealX{
    return currentScreen?.outputMode?.size?.x;
  }

  //当前屏幕的真实y
  int get currentScreenRealY{
    return currentScreen?.outputMode?.size?.y;
  }

  //当前屏幕背景是否显示
  int get bkgEnable{
    return currentScreen?.bkg?.enable;
  }

  //通过ID查找屏幕
  ScreenModel searchScreenById(int id) {
    int index = _screenList.indexWhere((p) => p.screenId == id);
    return index != -1 ? _screenList[index] : null;
  }

//通过ID查找屏幕索引
  int searchScreenIndexById(int id) {
    return _screenList.indexWhere((p) => p.screenId == id);
  }

//更新屏幕列表中的屏幕详情
  bool updateScreenModel(ScreenModel screenModel) {
    int index = _screenList.indexWhere((p) => p.screenId == screenModel.screenId);
    if (index != -1) {
      _screenList[index] = screenModel;
      notifyListeners();
      return true;
    } else
      return false;
  }

//增加屏幕
  bool addScreenModel(ScreenModel screenModel) {
    int index = _screenList.indexWhere((p) => p.screenId == screenModel.screenId);
    if (index == -1) {
      _screenList.add(screenModel);
      if(_screenList.length == 1) {
        _currentScreenId = _screenList[0].screenId;
      }
      notifyListeners();
      return true;
    } else
      return false;
  }

//删除屏幕
  bool delScreenModel(int screenId) {
    int index = _screenList.indexWhere((p) => p.screenId == screenId);
    if (index != -1) {
      _screenList.removeAt(index);
      notifyListeners();
      if(_screenList.length > 0 && screenId == currentScreenId) {
        // _currentScreenId = _screenList[_screenList.length-1].screenId;
        if(index == _screenList.length) {
          _currentScreenId = _screenList[_screenList.length-1].screenId;
        } else {
          _currentScreenId = _screenList[index].screenId;
        }
      }
      if(_screenList.length == 0) {
        _currentScreenId = -1;
      }
      return true;
    } else
      return false;
  }

  // 修改黑屏
  updateFtbByScreenId(int screenId, int ftb) {
    int index = _screenList.indexWhere((p) => p.screenId == screenId);
    if (index != -1) {
      if (_screenList[index].ftb != null) {
        _screenList[index].ftb.enable = ftb;
      } else {
        _screenList[index].ftb = new Ftb(enable: ftb);
      }

      if(ftb == 0) {
        if (_screenList[index].freeze != null && _screenList[index].freeze.enable == 1) {
          _screenList[index].freeze.enable = 0;
        } else {
          _screenList[index].freeze = new Freeze(enable: 0);
        }
      }
      notifyListeners();
    }
  }

  // 测试代码  可以删除
  set addScreen(value) {
    print('add 屏幕 ---: $value');
  }
  // 获取当前屏幕是否冻结enable

  void forceUpdate() {
    notifyListeners();
  }

  // 开窗
  createLayer(ScreenLayer layerModel) {
    int index = _screenList.indexWhere((screen) => screen.screenId == layerModel.screenId);
    if (index != -1) {
      int layerIndex =  _screenList[index].screenLayers.indexWhere((layer) => layer.layerId == layerModel.layerId);
      if(layerIndex == -1) {
        _screenList[index].screenLayers.add(layerModel);
        notifyListeners();
      }
    }
  }

  // 更新图层window信息
  updateScreenLayerWindow(Window layerSizeModel) {
    int index = _screenList.indexWhere((screen) => screen.screenId == layerSizeModel.screenId);
    if (index != -1) {
      int layerIndex =  _screenList[index].screenLayers.indexWhere((layer) => layer.layerId == layerSizeModel.layerId);
      if(layerIndex != -1) {
        _screenList[index].screenLayers[layerIndex].window = layerSizeModel;
        notifyListeners();
      }
    }
  }

  // 更新图层Z序
  updateScreenLayerZIndex(int screenId, socketData) {
    var layersZOrderList = socketData['layersZOrder'];
    int index = _screenList.indexWhere((screen) => screen.screenId == screenId);
    if (index != -1) {
      _screenList[index].screenLayers.forEach((layer) {
        var curZOrder = layersZOrderList.firstWhere((zOrder)=>(zOrder['layerId'] == layer.layerId), orElse: ()=> null);

        if(curZOrder != null) {
          layer.general.zorder = curZOrder['zOrder'];
          notifyListeners();
        }
      });
    }
  }

  // 更新图层信息
  updateScreenLayerGeneral(ScreenLayer layerModel) {
    int index = _screenList.indexWhere((screen) => screen.screenId == layerModel.screenId);
    if (index != -1) {
      int layerIndex =  _screenList[index].screenLayers.indexWhere((layer) => layer.layerId == layerModel.layerId);
      if(layerIndex != -1) {
        _screenList[index].screenLayers[layerIndex] = layerModel;
        notifyListeners();
      }
    }
  }

  // 删除图层
  deleteScreenLayer(int screenId, int layerId) {
    int index = _screenList.indexWhere((screen) => screen.screenId == screenId);
    if (index != -1) {
      int layerIndex =  _screenList[index].screenLayers.indexWhere((layer) => layer.layerId == layerId);
      if(layerIndex != -1) {
        _screenList[index].screenLayers.removeAt(layerIndex);
        notifyListeners();
      }
    }
  }

  // 清除图层
  clearScreenLayer(int screenId) {
    int index = _screenList.indexWhere((screen) => screen.screenId == screenId);
    if (index != -1) {
      _screenList[index].screenLayers.clear();
      notifyListeners();
    }
  }

  // 批量创建图层
  createBatchScreenLayer(int screenId, screenLayers) {
    int index = _screenList.indexWhere((screen) => screen.screenId == screenId);
    if (index != -1) {
      _screenList[index].screenLayers = screenLayers;
      notifyListeners();
    }
  }

  // 修改屏幕布局
  writeOutputMode(ScreenModel screenInfo) {
    int index = _screenList.indexWhere((screen) => screen.screenId == screenInfo.screenId);
    if (index != -1) {
      _screenList[index] = screenInfo;
      notifyListeners();
    }
  }

  // 修改屏幕BKG
  // 参数 {Map} socketData -推送的数据
  writeBkg(socketData) {
    int index = _screenList.indexWhere((screen) => screen.screenId == socketData['screenId']);
    if (index != -1) {
      _screenList[index].bkg.enable = socketData['enable'];
      if(socketData['enable'] == 1) {
        _screenList[index].bkg.imgUrl = socketData['imageUrl'];
      }
      notifyListeners();
    }
  }

  // 情况屏幕列表
  void clear() {
    _screenList.clear();
    notifyListeners();
  }

  bool _isBrightnessBtnSel = false;
  get isBrightnessBtnSel => _isBrightnessBtnSel;
  set isBrightnessBtnSel(bool value){
    if(value != _isBrightnessBtnSel){
      _isBrightnessBtnSel = value;
      notifyListeners();
    }
  }

  bool _forceUpdatePreset = false;
  get forceUpdatePreset => _forceUpdatePreset;
  set forceUpdatePreset(bool value){
    if(value != _forceUpdatePreset){
      _forceUpdatePreset = value;
      notifyListeners();
    }
  }

}
