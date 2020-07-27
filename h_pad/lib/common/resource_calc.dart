/*
 * @Description: 资源计算
 * @Author: ZuoSuqian
 * @Date: 2020-06-09 17:22:56
 * @LastEditors: ZuoSuqian
 * @LastEditTime: 2020-06-19 10:01:46
 */
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/style/index.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ResourceCalc {
  static List currentSlotIds = [];
  static int maxResource = 16; // 每个slot最多占用资源数
  static Map allSlotResource = {}; // 所有slot占用资源数{0: 2, 1: 3, 255: 1}
  static Map layerChangeBefore = {}; // 图层平移和缩放前的信息 {screenId, layerId, xOld, yOld, wOld, hOld}
  /*
   * @description: 资源计算,并存储资源占用情况
   * @param {List} screens 屏幕列表
   * @param {int} currentScreenId 当前屏幕Id
   * @param {List} layers 当前操作的图层对象数组[{id,x,y,w,h,connectCapacity}]
   * @return: {Bool} 资源是否超限[true-超限，false-未超限制]
   */
  static calcResource(List<ScreenModel> screens, int currentScreenId, List layers) {
    if(currentScreenId == -1) {
      return true;
    }
    List screenList = [];
    screens.forEach((screen) {
      Map screenInfo = {
        'screenId': screen.screenId,
        'screenLayers': json.decode(json.encode(screen.screenLayers)),
        'outputMode': json.decode(json.encode(screen.outputMode))
      };
      screenList.add(screenInfo);
    });

    List currentSlots = [];
    var curScreen = screenList.firstWhere((screen) => screen['screenId'] == currentScreenId, orElse: ()=>null);

    if(layers.length == 1 && !layers[0].containsKey('source')) {
      var layerInfo = layers[0];
      if(layerInfo.containsKey('id') && layerInfo.containsKey('connectCapacity')) { // 切源
        curScreen['screenLayers'].forEach((layer) {
          if(layer['general']['layerId'] == layerInfo['id']) {
            layer['source']['connectCapacity'] = layerInfo['connectCapacity'];
          }
        });
      } else if(layerInfo.containsKey('id')) { // 修改图层位置 大小
        curScreen['screenLayers'].forEach((layer) {
          if(layer['general']['layerId'] == layerInfo['id']) {
            layer['window']['x'] = layerInfo['x'];
            layer['window']['y']  = layerInfo['y'];
            layer['window']['width']  = layerInfo['w'];
            layer['window']['height']  = layerInfo['h'];
          }
        });
      } else { // 开窗
        curScreen['screenLayers'].add({
          'window': {
            'x': layerInfo['x'],
            'y': layerInfo['y'],
            'width': layerInfo['w'],
            'height': layerInfo['h']
          },
          'source': {
            'connectCapacity': layerInfo['connectCapacity']
          }
        });
      }

      // 获取 操作图层 所占的slot
      var screenInterfaces = curScreen['outputMode']['screenInterfaces'];
      screenInterfaces.forEach((output) {
        if(!currentSlots.contains(output['slotId'])) {
          var isOverlap = _checkOverlap({
            'x': layerInfo['x'].round(),
            'y': layerInfo['y'].round(),
            'width': layerInfo['w'].round(),
            'height': layerInfo['h'].round()
          }, {
            'x': output['x'].round(),
            'y': output['y'].round(),
            'width': output['width'].round(),
            'height': output['height'].round()
          });
          if(isOverlap) {
            currentSlots.add(output['slotId']);
          }
        }
      });
    } else if(layers.length > 0) { // 批量开窗
    curScreen['screenLayers'] = layers;
      // 获取 操作图层 所占的slot
      var screenInterfaces = curScreen['outputMode']['screenInterfaces'];
      screenInterfaces.forEach((output) {
        layers.forEach((layer) {
          if(!currentSlots.contains(output['slotId'])) {
            var isOverlap = _checkOverlap({
              'x': layer['window']['x'].round(),
              'y': layer['window']['y'].round(),
              'width': layer['window']['width'].round(),
              'height': layer['window']['height'].round()
            }, {
              'x': output['x'].round(),
              'y': output['y'].round(),
              'width': output['width'].round(),
              'height': output['height'].round()
            });
            if(isOverlap) {
              currentSlots.add(output['slotId']);
            }
          }
        });
      });
    }

    // 收集所有屏幕所有图层下的每个非重复子卡的资源占用情况
    List slotList = [];
    screenList.forEach((screen) {
      screen['screenLayers'].forEach((layer) {
        /*
         * 以slotId为key判断每个图层下所有非重复slotId的子卡
         * 将找到的非重复的子卡的占用资源给slotId
         */
        Map slots = {};
        screen['outputMode']['screenInterfaces'].forEach((output) {
          if(!slots.containsKey(output['slotId'])) {
            var isOverlap = _checkOverlap({
              'x': layer['window']['x'].round(),
              'y': layer['window']['y'].round(),
              'width': layer['window']['width'].round(),
              'height': layer['window']['height'].round(),
            }, {
              'x': output['x'].round(),
              'y': output['y'].round(),
              'width': output['width'].round(),
              'height': output['height'].round()
            });
            if(isOverlap) {
              slots[output['slotId']] = _getResource(layer['source']['connectCapacity'], layer['source']);
            }
          }
        });
        slotList.add(slots);
      });
    });

    // 没slot时不需要计算
    if(slotList.length == 0) {
      return false;
    }
    // 汇总出每个子卡的总占用资源
    Map slotResource = {};
    slotList.forEach((slot) {
      slot.forEach((key, value) {
        if(slotResource.containsKey(key)) {
          slotResource[key] += value;
        } else {
          slotResource[key] = value;
        }
      });
    });
    setSlotResource(slotResource);
    currentSlotIds = currentSlots;
    print('汇总后，每个子卡的总占用资源:  $slotResource');
    bool isOver = checkResourceOver();
    if(isOver) {
      showTipToast();
    }

    return isOver;
  }

  /*
   * @description: 检测资源是否超限
   * @return: 返回true超限，false不超限
   */
  static bool checkResourceOver() {
    print('allSlotResource $allSlotResource');
    var isOver = false;
    currentSlotIds.forEach((slotId) {
      if(slotId != 255 && allSlotResource[slotId] > maxResource) {
        isOver = true;
      }
    });
    print('是否超资源：${isOver}');
    return isOver;
  }

  // 设置每个slot 占用资源数
  static setSlotResource(resource) {
    allSlotResource = resource;
    print( '======${ResourceCalc.allSlotResource}====');
  }

  /*
   * @description: 获取资源数量
   * @param {int} connectCapacity 连接容量
   * @return: {int} 资源数
   */
  static _getResource(int connectCapacity, Map source) {
    if(source['sourceType'] == 0) { // 特殊处理sourceType 为0的时候默认占一个资源
      return 1;
    }
    int resource = 0;
    if(connectCapacity == 0) {
      resource = 1;
    } else if(connectCapacity == 1) {
      resource = 2;
    } else if(connectCapacity == 2) {
      resource = 4;
    }
    // print('占用资源数 $resource');
    return resource;
  }

  /*
   * @description: 计算两个容器是否交叠
   * @param {Map} r1 第一个容器 {width, height, x, y}
   * @param {Map} r2 第二个容器形
   * @return: 是否交叠
   */
  static _checkOverlap(r1, r2) {
    return !((r1['x'] + r1['width'] <= r2['x']) || (r1['x'] >= r2['x'] + r2['width']) || (r1['y'] + r1['height'] <= r2['y']) || (r1['y'] >= r2['y'] + r2['height']));
  }

  // 设置图层平移缩放前的信息
  // static setLayerChangeBefore(layerBefore) {
  //   layerChangeBefore = layerBefore;
  // }

  // 弹回之前的位置坐标
  // List layerChangeBefore 图层平移和缩放前的信息 [{screenId, layerId, xOld, yOld, wOld, hOld}]
  static reBackPos(List<Map> layerChangeBefore) {

  }

  static showTipToast() {
    Fluttertoast.showToast(
      msg: "资源超限，操作无效",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: ColorMap.toast_error_color,
      textColor: ColorMap.white,
      gravity: ToastGravity.TOP);
  }
}
