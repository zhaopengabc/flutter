import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/device/DeviceDetail.dart';
import 'package:h_pad/models/edit/ScreenListModel.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/preset/PresetGroupModel.dart';
import 'package:h_pad/models/main/NomarkModeModle.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/states/device/deviceProvider.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/LayerTipProvider.dart';
import 'package:h_pad/states/index.dart';
import 'package:h_pad/states/main/NomarkModeProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/api/websocket/websocket.dart';

class SocketData {

  BuildContext context;

  WebSocketUtil socketUtil = WebSocketUtil.getInstance();
  
  bool _isPush = true; // 是否持续接收推送数据（限流）

  SocketData(BuildContext ctxt){
    context = ctxt;
    // socketUtil = WebSocketUtil.getInstance();
  }

  // 处理多用户同步数据
  void onReceiveData(data) {
    Map map = json.decode(data);
    _checkSocketStates(map);
  }

  // 处理推送跳转路由
  void _checkSocketStates(Map params) {
    if (params['name'] != null) {
      if (params['name'] == 'device/writeIp') {
        // 修改了IP后的推送
        final ipData = params['data']['ip'];
        if (ipData) {
          String newIP = 'http://${ipData.ip0}.${ipData.ip1}.${ipData.ip2}.${ipData.ip3}';
          Global.setBaseUrl = newIP;
        }
      } else if (params['name'] == 'device/upgradeStatus' && _isPush) {
        // 设备升级跳转设备搜索页面
        socketUtil.closeManual(true); // 强制关闭socket
        _isPush = false;
        Provider.of<EditProvider>(context, listen: false).currentScreenId = -1;
        Provider.of<EditProvider>(context, listen: false).flickerLayerId = -1;
        Provider.of<EditProvider>(context, listen: false).screenList = new List();
        if (null != ModalRoute.of(context).settings.name && ModalRoute.of(context).settings.name != 'Init') {
          Navigator.pushNamed(context, 'Init');
        }
      } else if (params['name'] == 'device/shutdown' && _isPush) {
        // 恢复出厂重启初始化
        _isPush = false;
        
        Provider.of<EditProvider>(context, listen: false).currentScreenId = -1;
        Provider.of<EditProvider>(context, listen: false).flickerLayerId = -1;
        Provider.of<EditProvider>(context, listen: false).screenList = new List();
        if (null != ModalRoute.of(context).settings.name && ModalRoute.of(context).settings.name != 'Init') {
          socketUtil.closeManual(true); // 强制关闭socket
          Navigator.pushNamed(context, 'Init');
        }
      } else if (params['token'] != Global.getToken) {
        // 非自身导致的推送信息
        socketDataHandler(params);
      }
    } else {
      print('无效业务');
    }
  }

  // 同步 socket 数据
  void socketDataHandler(params) {
    // print('ModalRoute.of(context).settings.name: ${ModalRoute.of(context).settings.name} --------推送数据:${params['name']}');
    if (ModalRoute.of(context).settings.name == 'Edit') {
      // 添加router 限制
      switch (params['name']) {
        case 'screen/readAllList':
          _screenList(params);
          break;
        case 'screen/createScreen':
          _addScreen(params);
          break;
        case 'screen/deleteScreen':
          _deleteScreen(params);
          break;
        case 'screen/ftb':
          _ftb(params);
          break;
        case 'screen/writeBrightness':
          _brightness(params);
          break;
        case 'screen/writeFreeze':
          _freeze(params);
          break;
        case 'screen/writeOutputMode':
          _writeOutputMode(params);
          break;  
        case 'preset/readList':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            int curScreenX = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.x;
            int curScreenY = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.y;
            List<Preset> presetList = List();
            params['data']['presets']?.forEach((preset) {
              preset['layers']?.forEach((layer) {
                layer['window']['x'] -= curScreenX;
                layer['window']['y'] -= curScreenY;
              });
              presetList.add(Preset.fromJson(preset));
            });
            Provider.of<PresetProvider>(context, listen: false).presetList = presetList;
            Provider.of<PresetProvider>(context, listen: false).forceUpdate();
          }
          break;
        case 'preset/play':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            _loadPreset(params['data']['presetId'], params['data']['screenId']);
          }
          break;
        case 'preset/add':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            // int curScreenX = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.x;
            // int curScreenY = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.y;
            // params['data']['layers']?.forEach((layer) {
            //   layer['window']['x'] -= curScreenX;
            //   layer['window']['y'] -= curScreenY;
            // });
            Preset preset = Preset.fromJson(params['data']);
            Provider.of<PresetProvider>(context, listen: false).presetList.add(preset);
            Provider.of<PresetProvider>(context, listen: false).forceUpdate();
          }
          break;
        case 'preset/deletePreset':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            Provider.of<PresetProvider>(context, listen: false).deletePreset(params['data']['presetId']);
          }
          break;
        case 'preset/writeGeneral':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            Provider.of<PresetProvider>(context, listen: false).renamePreset(params['data']['presetId'], params['data']['name']);
          }
          break;
        case 'preset/groupList':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId']) {
            int curScreenX = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.x;
            int curScreenY = Provider.of<EditProvider>(context, listen: false).currentScreen.outputMode.size.y;
            List<PresetGroup> presetGroupList = List();
            params['data']['presetGroups']?.forEach((element) {
              element['presets']?.forEach((preset) {
                preset['layers']?.forEach((layer) {
                  layer['window']['x'] -= curScreenX;
                  layer['window']['y'] -= curScreenY;
                });
              });
              presetGroupList.add(PresetGroup.fromJson(element));
            });
            Provider.of<PresetGroupProvider>(context, listen: false).presetGroupList = presetGroupList;
            Provider.of<PresetGroupProvider>(context, listen: false).forceUpdate();
          }
          break;
        case 'preset/readPresetPoll':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == -1) {
            return null;
          }
          ScreenModel pushScreen = Provider.of<EditProvider>(context, listen: false)
              .screenList
              .firstWhere((element) => element.screenId == params['data']['screenId'], orElse: () => null);
          PresetPoll presPoll =
              PresetPoll(enable: params['data']['enable'], presetGroupId: params['data']['presetGroupId']);
          if(pushScreen != null){
            pushScreen.presetPoll = presPoll;
            Provider.of<EditProvider>(context, listen: false).forceUpdate();
          }
          break;
        case 'preset/pollPlay':
          if (Provider.of<EditProvider>(context, listen: false).currentScreenId == params['data']['screenId'] &&
              Provider.of<EditProvider>(context, listen: false).currentScreen.presetPoll.enable == 1) {
            // 推送过来的当前播放的场景
            Provider.of<PresetGroupProvider>(context, listen: false).pollPresetId = params['data']['presetId'];
            _loadPreset(params['data']['presetId'], params['data']['screenId']);
          } else { // 非当前屏幕下的轮巡播放场景id不处理
            // print('非当前屏幕下的轮训当前播放场景id不处理');
            // Provider.of<PresetGroupProvider>(context, listen: false).pollPresetId = -1;
          }
          Provider.of<PresetProvider>(context, listen: false).forceUpdate();
          break;
        case 'main/nomarkData':
          _nomarkMode(params);
          break;
        case 'layer/create':
          ScreenLayer layerModel = ScreenLayer.fromJson(params['data']);
          Provider.of<EditProvider>(context, listen: false).createLayer(layerModel);
          Provider.of<EditProvider>(context, listen: false).selectedLayerId = -1;
          _setLayerTip(params);
          break;
        case 'layer/writeWindow':
          Window layerSizeModel = Window.fromJson(params['data']);
          Provider.of<EditProvider>(context, listen: false).updateScreenLayerWindow(layerSizeModel);
          _setLayerTip(params);
          break;
        case 'layer/writeZIndex':
          Provider.of<EditProvider>(context, listen: false).updateScreenLayerZIndex(params['data']['screenId'], params['data']);
          break;
        case 'layer/writeSource':
        case 'layer/writeGeneral':
        case 'layer/writeLock':
        case 'layer/freeze':
          ScreenLayer layerModel = ScreenLayer.fromJson(params['data']);
          Provider.of<EditProvider>(context, listen: false).updateScreenLayerGeneral(layerModel);
          _setLayerTip(params);
          break;
        case 'layer/delete':
          Provider.of<EditProvider>(context, listen: false).deleteScreenLayer(params['data']['screenId'], params['data']['layerId']);
          break;
        case 'layer/deleteBatch':
          Provider.of<EditProvider>(context, listen: false).clearScreenLayer(params['data']['screenId']);
          break;
        case 'layer/screenLayerTake':
          _createLayerBatch(params);
          break;
        case 'screen/writeGeneral':
        case 'screen/writeOutputMode':
          _writeScreen(params);
          break;
        case 'screen/writeBKG':
          Provider.of<EditProvider>(context, listen: false).writeBkg(params['data']);
          break;
        case 'input/readList':
          _inputList(params);
          break;
        case 'device/readDetail':
          _deviceDetail(params);
          break;
        default:
          // print('推送数据name:${params['name']} user:${params['user']} ---- 未处理');
          // print('目前不需要的处理的推送---------------start');
          // print('推送数据name:${params['name']}');
          // print('推送数据data:${params['data']}');
          // print('user:${params['user']}');
          // print('目前不需要的处理的推送---------------over');
          break;
      }
    } else {
      //
      //print('目前不需要的处理的推送----非当前路由-----------start');
      // print('推送数据name:${params['name']} user:${params['user']} ---- 非当前路由');
      //print('user:${params['user']}');
      // print('推送数据data:${params['data']}');
      //print('目前不需要的处理的推送---------------over');
    }
  }
  //置空场景数据
  _clearPresetData() {
    Provider.of<PresetProvider>(context, listen: false).currentPresetId = -1;
    Provider.of<PresetProvider>(context, listen: false).clear();
    Provider.of<PresetGroupProvider>(context, listen: false).currentPresetGroupId = -1;
    Provider.of<PresetGroupProvider>(context, listen: false).clear();
    Provider.of<EditProvider>(context, listen: false).currentScreenId = -1;
    Provider.of<EditProvider>(context, listen: false).clear();
  }
  //屏幕列表
  _screenList(params) {
    if (params['data'].length == 0) { // 清空屏幕列表时场景、场景轮巡置空
      _clearPresetData();
    }
    ScreenListInfoModel screenListInfo = ScreenListInfoModel.fromJson(params['data']);
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    var currentScreen = screenListInfo.screenList.firstWhere((p)=>p.screenId == editProvider.currentScreenId, orElse: ()=>null);
    Provider.of<EditProvider>(context, listen: false).screenList = screenListInfo.screenList;
    if(currentScreen == null) {
      editProvider.currentScreenId = screenListInfo.screenList.length > 0 ? screenListInfo.screenList[0].screenId : -1;
    }
  }

  //增加屏幕
  _addScreen(params) {
    // print('新建屏幕了');
    ScreenModel screenInfo = ScreenModel.fromJson(params['data']);
    Provider.of<EditProvider>(context, listen: false).addScreenModel(screenInfo);
    Provider.of<EditProvider>(context, listen: false).forceUpdate();
  }

  //删除屏幕
  _deleteScreen(params) {
    // debugger(message: '删除屏幕了');
    int sLen = Provider.of<EditProvider>(context, listen: false).screenList.length;
    if (sLen - 1 == 0) { // 删除最后一个屏幕的时候
      _clearPresetData();
    }
    int screenId = params['data']['screenId'];
    Provider.of<EditProvider>(context, listen: false).delScreenModel(screenId);
  }

  //更改黑屏
  _ftb(params) {
    int ftb = params['data']['type'];
    int screenId = params['data']['screenId'];
    Provider.of<EditProvider>(context, listen: false).updateFtbByScreenId(screenId, ftb);
  }

  //屏幕冻结
  _freeze(params) {
    Freeze freeze = Freeze.fromJson(params['data']);
    Provider.of<EditProvider>(context, listen: false).currentScreen.freeze = freeze;
    if(Provider.of<EditProvider>(context, listen: false).currentScreen.ftb.enable == 0) {
      Provider.of<EditProvider>(context, listen: false).currentScreen.ftb.enable = 1;
    }
    Provider.of<EditProvider>(context, listen: false).forceUpdate();
  }

  //输出列表
  _outputList(params) {}

  //调节亮度
  _brightness(params) {
    int brightness = params['data']['brightness'];
    Provider.of<EditProvider>(context, listen: false).currentScreen.screenBrightness = brightness;
    Provider.of<EditProvider>(context, listen: false).forceUpdate();
  }
   // 批量创建图层
  _createLayerBatch(params) {
    List<ScreenLayer> layerList = new List<ScreenLayer>();
    params['data']['layers']?.forEach((layer) {
      ScreenLayer layerModel = ScreenLayer.fromJson(layer);
      layerModel.screenId = params['data']['screenId'];
      layerList.add(layerModel);
    });
    Provider.of<EditProvider>(context, listen: false).createBatchScreenLayer(params['data']['screenId'], layerList);
  }

  // 修改屏幕布局、名称等信息
  _writeScreen(params) {
    Provider.of<EditProvider>(context, listen: false).writeOutputMode(ScreenModel.fromJson(params['data']));
  }

  //设置屏幕布局信息
  _writeOutputMode(params){
    final screenJson = json.encode(params['data']);
    var screenInfo = json.decode(screenJson);
    ScreenModel screenModel = ScreenModel.fromJson(screenInfo);

    // 更新屏幕详情数据
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    int index = editProvider.searchScreenIndexById(screenModel.screenId);
    if(index != -1) {
      editProvider.screenList[index] = screenModel;
      if(screenModel.screenId == editProvider.currentScreenId){
        editProvider.forceUpdatePreset = true;
      }
      editProvider.forceUpdate();
    }
  }
  //场景应用

  /*
   * @description: 加载图层
   * @param { int } pid 场景id
   * @param { int } sid 屏幕id
   */
  void _loadPreset(int pid, int sid) {
    List<ScreenLayer> layerList = List<ScreenLayer>();
    Preset preset =
        Provider.of<PresetProvider>(context, listen: false).presetList?.firstWhere(
          (element) => element.presetId == pid,
          orElse: () => null
        );
    preset?.layers?.forEach((element) {
      Map layer = {
        "deviceId": 0,
        "layerId": element.general.layerId,
        "lock": {"lock": 0},
        "screenId": sid,
        "general": element.general,
        "source": element.source,
        "window": element.window
      };
      layerList.add(ScreenLayer.fromJson(json.decode(json.encode(layer))));
    });
    if(layerList.length == 0) return;
    // Provider.of<EditProvider>(context, listen: false)
    //     .screenList
    //     .firstWhere((element) => element.screenId == sid, orElse: () => null)
    //     .screenLayers = layerList;
    Provider.of<EditProvider>(context, listen: false).currentScreen.screenLayers = layerList;
    Provider.of<PresetProvider>(context, listen: false).currentPresetId = pid;
    Provider.of<EditProvider>(context, listen: false).forceUpdate();
  }

  //中性状态
  _nomarkMode(params){
    NomarkModeInfo nomarkModeInfo = NomarkModeInfo.fromJson(params['data']);
    Provider.of<NomarkModeProvider>(context, listen: false).nomarkModeInfo = nomarkModeInfo;
  }

  //输入列表
  _inputList(params){
    final list = params['data'];
    List<dynamic> listJson = json.decode(json.encode(list));
    List<InputModel> inputList =  
        listJson.map((value) => new InputModel.fromJson(value)).toList();  
    Provider.of<InputProvider>(context, listen: false).inputList = inputList;
  }
  //设备详情
  _deviceDetail(params){
    final detailJson = json.encode(params['data']);
    var detailInfo = json.decode(detailJson);
    DeviceDetail detail = DeviceDetail.fromJson(detailInfo);
    Provider.of<DeviceDetailProvider>(context, listen: false).deviceDetail = detail;
  }

  _setLayerTip(params){
    if(params['data']['screenId']== Provider.of<EditProvider>(context, listen: false).currentScreenId){
      Provider.of<LayerTipProvider>(context, listen: false).setCustomerLayerTips(new LayerTip(
      screenId: params['data']['screenId'], 
      layerId: params['data']['layerId'], 
      user: params['user'], 
      tipState: true
      ));
    }
  }
}