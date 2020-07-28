/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-01 11:41:31
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-03 16:48:43
 */ 
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/output/ConnectCapacityModel.dart';
import 'package:h_pad/models/output/OutputModel.dart';
import 'package:h_pad/models/screen/OutPutModel.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';

class ResourceCalculation {
  static List<ScreenConnectCapacityModel> screenConnectCapacityList = new List();
  // static List<SlotCard> cardConnectCapacityList = new List();

  // getTotalConnectCapacityNum(List<OutputModel> outputList){
  //   if(outputList.length <= 0) return;
  //   cardConnectCapacityList.clear();
  //   for(int i=0; i<outputList.length; i++) {
  //     cardConnectCapacityList.add(new SlotCard(slotId: outputList[i].slotId, totalConnectCapacity: 16, occupiedConnectCapacity: 0));
  //   }
  // }

  culScreenOccupation(List<ScreenModel> screenList){
    screenList.forEach((item){
      var totalSource = 0;
      int occupiedSource = 0;
      var filterdInterfaces = item.outputMode?.screenInterfaces?.where((f)=> f.slotId != 255);
      if(filterdInterfaces!=null){
        filterdInterfaces = filterdInterfaces.toList();
        Map<int, List<ScreenInterface>> map = new Map.fromIterable(filterdInterfaces,
         key: (key) => key.slotId,
         value: (value) {
            return filterdInterfaces.where((p) => p.slotId == value.slotId).toList();
         });
        totalSource = map.length * 16;
      }
      item.screenLayers.forEach((layer){
        if(layer.source?.connectCapacity == 0){
          occupiedSource += 1;
        }else if(layer.source?.connectCapacity == 1){
          occupiedSource += 2;
        }else if(layer.source?.connectCapacity == 2){
          occupiedSource += 4;
        }
      });
      screenConnectCapacityList.add(new ScreenConnectCapacityModel(
        screenId: item.screenId,
        totalConnectCapacity: totalSource,
        occupiedConnectCapacity: occupiedSource  
      ));
    });
    return screenConnectCapacityList;
  }

  static currentScreenOccupation(List<ScreenModel> screenList, int currentScreenId, int requestCapacity){
    if(screenList == null || screenList.length<=0  || requestCapacity == null || requestCapacity < 0) return false;
    ScreenModel screen = screenList.firstWhere((p)=>p.screenId==currentScreenId, orElse: ()=>null);
    var totalSource = 0;
    int occupiedSource = 0;
    bool canOpenSource = true;
    var filterdInterfaces = screen.outputMode?.screenInterfaces?.where((f)=> f.slotId != 255);
    //屏幕有输入卡
    if(filterdInterfaces!=null && filterdInterfaces.length > 0){
      filterdInterfaces = filterdInterfaces.toList();
      Map<int, List<ScreenInterface>> map = new Map.fromIterable(filterdInterfaces,
        key: (key) => key.slotId,
        value: (value) {
          return filterdInterfaces.where((p) => p.slotId == value.slotId).toList();
        });
      totalSource = map.length * 16;
    } else { //屏幕没有输入卡，图层随便开
      return canOpenSource;
    }
    screen.screenLayers.forEach((layer){ //不管有源无源，只看connectCapacity
      int occupiedNum = _getRequestNum(layer.source?.connectCapacity);
      occupiedSource += occupiedNum;
    });
    var requestNum = _getRequestNum(requestCapacity);
    if( requestNum > totalSource - occupiedSource) {
      canOpenSource = false;
    }
    print('图层数量：${screen.screenLayers.length}---屏幕ID：$currentScreenId----totalSource：$totalSource----occupiedSource：$occupiedSource------requestNum：$requestNum');
    // new ScreenConnectCapacityModel(
    //   screenId: currentScreenId,
    //   totalConnectCapacity: totalSource,
    //   occupiedConnectCapacity: occupiedSource  
    // );
    return canOpenSource;
  }

  //连接容量转化成所占资源数量
  static int _getRequestNum(int connectCapacity){
    if(connectCapacity == null) return 0;
    int requestNum = 0;
    if(connectCapacity == 0){
      requestNum = 1;
    }else if(connectCapacity == 1){
       requestNum = 2;
    }else if(connectCapacity == 2){
      requestNum = 4;
    }
    return requestNum;
  }
}
