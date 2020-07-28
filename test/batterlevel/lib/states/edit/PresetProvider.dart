import 'package:flutter/material.dart';
import 'package:h_pad/models/preset/PresetModel.dart';
import 'package:h_pad/models/preset/PresetGroupModel.dart';

class PresetProvider with ChangeNotifier {
  // 场景列表
  List<Preset> _presetList = new List();
  List<Preset> get presetList => _presetList;

  set presetList(List<Preset> pList) {
    // 场景根据createTime排序，最新创建的在下面
    if (pList.length > 0 && pList[0].createTime != null) {
      pList.sort((a, b) => a.createTime.compareTo(b.createTime));
    }
    if (_presetList != pList) {
      _presetList = pList;
      notifyListeners();
    }
  }

  // 当前场景id
  int _currentPresetId = -1;
  int get currentPresetId => _currentPresetId;
  set currentPresetId(int value) {
    _currentPresetId = value;
    notifyListeners();
  }
  // int _currentPresetId = -1;
  // int get currentPresetId => _currentPresetId;
  // set currentPresetId(int value) {
  //   _currentPresetId = value;
  //   notifyListeners();
  // }

  // 当前选中场景
  Preset get currentPreset{
    var currentPreset;
    var preset = _presetList.firstWhere((p) => p.presetId == _currentPresetId, orElse: () => null);
    if (preset != null) {
      currentPreset = preset;
    }
    return currentPreset;
  }
  // set currentPreset(Preset value) {
  //   if (value != null) {
  //     _currentPreset = value;
  //     notifyListeners();
  //   }
  // }
  // Preset get currentPreset {
  //   int index = _presetList.indexWhere((element) => element.presetId == _currentPresetId);
  //   return index != -1 ? _presetList[index] : null;
  // }

  // 删除场景
  deletePreset(int pid) {
    int index = _presetList.indexWhere((preset) => preset.presetId == pid);
    if (index != -1) {
      _presetList.removeAt(index);
      notifyListeners();
    }
  }

  // 重命名
  renamePreset(int pid, String name) {
    Preset preset = _presetList.firstWhere((preset) => preset.presetId == pid, orElse: () => null);
    if (preset != null) {
      preset.name = name;
      notifyListeners();
    }
  }

  void forceUpdate() {
    notifyListeners();
  }

  // 清空场景列表
  void clear() {
    _presetList.clear();
    notifyListeners();
  }
}

class PresetGroupProvider with ChangeNotifier {
  // 场景轮询列表
  List<PresetGroup> _presetGroupList = new List();
  List<PresetGroup> get presetGroupList => _presetGroupList;
  set presetGroupList(List<PresetGroup> pList) {
    if (_presetGroupList != pList) {
      _presetGroupList = pList;
      notifyListeners();
    }
  }

  // 当前场景轮询id
  // int _currentPresetGroupId = -1;
  // int get currentPresetGroupId => _currentPresetGroupId;
  // set currentPresetGroupId(int value) {
  //   _currentPresetGroupId = value;
  //   var presetGroup =
  //       _presetGroupList.firstWhere((p) => p.presetGroupId == value, orElse: () => null);
  //   if (presetGroup != null) {
  //     currentPresetGroup = presetGroup;
  //   }
  // }
  int _currentPresetGroupId = -1;
  int get currentPresetGroupId => _currentPresetGroupId;
  set currentPresetGroupId(int value) {
    _currentPresetGroupId = value;
    notifyListeners();
  }

  // 当前选中场景轮询
  // PresetGroup _currentPresetGroup;
  // PresetGroup get currentPresetGroup => _currentPresetGroup;
  // set currentPresetGroup(PresetGroup value) {
  //   if (value != null) {
  //     _currentPresetGroup = value;
  //     notifyListeners();
  //   }
  // }
  
  // 当前轮巡播放的场景
  int _pollPresetId = -1;
  int get pollPresetId => _pollPresetId;
  set pollPresetId(int value){
    _pollPresetId = value;
    notifyListeners();
  }

  PresetGroup get currentPresetGroup {
    int index = _presetGroupList.indexWhere((element) => element.presetGroupId == _currentPresetGroupId);
    return index != -1 ? _presetGroupList[index] : null;
  }

  void forceUpdate() {
    notifyListeners();
  }

  // 清空场景轮巡列表
  void clear() {
    _presetGroupList.clear();
    notifyListeners();
  }
}
