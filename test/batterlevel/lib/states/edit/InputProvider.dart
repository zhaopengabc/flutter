import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/device/DeviceDetail.dart';
import 'package:h_pad/models/input/InputModel.dart';

class InputProvider with ChangeNotifier {
  //输入列表
  List<InputModel> _inputList = new List();
  List<InputModel> get inputList => _inputList;
  set inputList(List<InputModel> pList) {
    if(_inputList != pList){
      _inputList = pList;//pList.where((p)=>p.online == 1).toList();
      notifyListeners();
    }
  }
  List<InputModel> get onlineInputList {
    List<InputModel> tempList = _inputList.where((p)=>p.online!= 0).toList();
    List<InputModel> inputList1 = new List();
    List<InputModel> inputList2 = new List();
    tempList.forEach((f){
      // print('输入列表是否在线----${f.online}');
      if(f.iSignal==1){
        inputList1.add(f);
      }else{
        inputList2.add(f);
      }
    });
    List<InputModel> inputList = new List.from(inputList1)..addAll(inputList2);
    return inputList;
  }

  //当前选中输入源id
  int _currentInputId = -1;
  int get currentInputId => _currentInputId;
  set currentInputId(int value) {
    if(value != null){
      _currentInputId = value;
      notifyListeners();
    }
  }

  //当前选中输入截取 Map<inputId,cropId>
  Map<int, int> _currentCrop = Map<int,int>();
  int getCurrentCropId(inputId){
    return _currentCrop[inputId];
  }
  setCurrentCrop(int inputId,int cropId) {
    _currentCrop.clear();
    _currentCrop[inputId] = cropId;
    notifyListeners();
  }

  //当前选中输入源
  InputModel get currentInput {
    int index = _inputList.indexWhere((p) => p.inputId == _currentInputId);
    return index != -1 ? _inputList[index] : null;
  }

  //通过ID查找输入源索引
  int searchInputIndexById(int id) {
    return _inputList.indexWhere((p) => p.inputId == id);
  }
  
  //通过输入ID，截取ID查找输入源index
  int findInputSourceById(int inputId, int cropId){
    int index = -1;
    index = onlineInputList.indexWhere((p) => p.inputId == inputId);
    // if(index != -1 && cropId != 255){
    //   var cropIndex = onlineInputList[index].crops.indexWhere((q) => q.cropId == cropId);
    //   if(cropIndex == -1){
    //     index = -1;
    //   }
    // }
    return index;
  }
  int findCropSourceById(InputModel inputModel, int cropId){
    int index = -1;
    if(inputModel == null || inputModel.crops == null || cropId == 255) return index;
    var cropIndex = inputModel.crops.indexWhere((q) => q.cropId == cropId);
    return cropIndex;
  }

  //根据设备详情信息，更新输入源是否有信号
  updateInput(DeviceDetail detail) {
    detail.slotList.forEach((p){
      int slotIndex = onlineInputList.indexWhere((q) => q.slotId == p.slotId);
      if(slotIndex != -1){
        int interfaceIndex = p.interfaces.indexWhere((f) => f.interfaceId == onlineInputList[slotIndex].interfaceId);
        if(interfaceIndex != -1){
          Map input = {
            "deviceId": 0,
            "inputId": onlineInputList[slotIndex].inputId,
            "slotId": onlineInputList[slotIndex].slotId,
            "interfaceId": onlineInputList[slotIndex].interfaceId,
            "interfaceType": onlineInputList[slotIndex].interfaceType,
            "iSignal": p.interfaces[interfaceIndex].iSignal,
            "isEDIDSetting": onlineInputList[slotIndex].isEDIDSetting,
            // "general": inputList[slotIndex].general,
            // "resolution": inputList[slotIndex].resolution,
            // "timing": inputList[slotIndex].timing,
            // "crops": inputList[slotIndex].crops,
          };
          var temp = InputModel.fromJson(json.decode(json.encode(input)));
          temp.general =  onlineInputList[slotIndex].general;
          temp.resolution = onlineInputList[slotIndex].resolution;
          temp.crops = onlineInputList[slotIndex].crops;
          onlineInputList[slotIndex] = temp;
          // print('修改的输入名称----${onlineInputList[slotIndex].general?.name}------${onlineInputList[slotIndex].iSignal}');
          notifyListeners();
        }
      }
    });
  }
}
