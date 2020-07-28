// 场景轮巡
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/states/edit/PresetProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/models/preset/PresetModel.dart';
import 'package:h_pad/models/preset/PresetGroupModel.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class PresetGroupListView extends StatefulWidget {
  @override
  _PresetGroupListViewState createState() => _PresetGroupListViewState();
}

class _PresetGroupListViewState extends State<PresetGroupListView> {

  int isFreeze = 0; // 是否冻结屏幕，0不冻结，1冻结
  int isLock = 0; // 是否锁屏，0不锁屏，1锁屏
  bool isPoll = false; // 是否轮巡
  int currentScreenId = -1; // 当前屏幕id
  int currentPresetGroupId = -1; // 当前场景轮巡id
  ScreenModel currentScreen = ScreenModel();

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    PresetGroupProvider presetGroupProvider = Provider.of<PresetGroupProvider>(context);

    isFreeze = editProvider.currentScreen?.freeze?.enable;
    isLock = editProvider.currentScreen?.isLock;
    isPoll = editProvider.currentScreen?.presetPoll?.enable == 1 ? true : false;

    currentScreen = editProvider.currentScreen;
    currentScreenId = editProvider.currentScreenId;
    currentPresetGroupId = presetGroupProvider.currentPresetGroupId;

    // return SingleChildScrollView(
    //   child: Container(
    //     color: ColorMap.input_background,
    //     child: ExpansionPanelList.radio(
    //       initialOpenPanelValue: -1,
    //       expansionCallback: (index, isExpanded) {

    //       },
    //       children: presetGroupProvider.presetGroupList.map<ExpansionPanelRadio>((PresetGroup presetGroup) {
    //         return ExpansionPanelRadio(
    //           value: presetGroup.presetGroupId,
    //           headerBuilder: (BuildContext context, bool isExpanded) {
    //             return ListTile(
    //               title: Text(presetGroup.name),
    //             );
    //           },
    //           body: Container(
    //             padding: EdgeInsets.zero,
    //             child: ListView.builder(
    //               padding: EdgeInsets.zero,
    //               shrinkWrap: true,
    //               physics: NeverScrollableScrollPhysics(),
    //               itemCount: presetGroup.presets.length,
    //               itemBuilder: (context, index) {
    //                 return ListTile(
    //                   title: Text('${presetGroup.presets[index].name}'),
    //                   leading: Icon(Icons.arrow_right),
    //                 );
    //               },
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );

    return Container(
      color: ColorMap.input_background,
      height: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: presetGroupProvider.presetGroupList?.length,
        itemBuilder: (context, index) {
          return Container(
            height: Utils.setHeight(52),
            decoration: BoxDecoration(
              color:
                isPoll && presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId
                ? ColorMap.input_background_normal : ColorMap.input_background,
              border: Border(
                left: BorderSide(
                  width: isPoll && presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId
                  ? Utils.setWidth(1.8) : Utils.setWidth(0.000001),
                  color: ColorMap.orange_selected
                ),
                bottom: BorderSide(
                  width: Utils.setWidth(0.5),
                  color:
                  isPoll && presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId
                  ? ColorMap.input_background_normal : ColorMap.border_color_item
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: isPoll && presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId
                  ? Utils.setWidth(17.000001) : Utils.setWidth(18.8),
                  width: Utils.setWidth(70),
                  child: Text(
                    '${presetGroupProvider.presetGroupList[index].name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                      isPoll && presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId
                      ? ColorMap.white : ColorMap.button_font_color,
                      fontSize: Utils.setFontSize(14),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 8.0),
                  child: Offstage(
                    offstage: isFreeze == 1 || isLock == 1 || presetGroupProvider.presetGroupList[index]?.presets?.length == 0,
                    child: MaterialButton(
                      height: Utils.setHeight(50),
                      minWidth: Utils.setWidth(50),
                      child: isPoll && editProvider.currentScreen?.presetPoll?.presetGroupId == presetGroupProvider.presetGroupList[index].presetGroupId
                      ? ImageIcon(AssetImage('assets/images/preset/icon_stop@2x.png'), color: ColorMap.white)
                      : ImageIcon(AssetImage('assets/images/preset/icon_play@2x.png'), color: ColorMap.grey),
                      onPressed: () {
                        presetGroupProvider.currentPresetGroupId = presetGroupProvider.presetGroupList[index].presetGroupId;
                        Provider.of<EditProvider>(context, listen: false).selectedLayerId = -1;
                        presetGroupPoll(presetGroupProvider.presetGroupList[index].presetGroupId, editProvider);
                      },
                    ),
                  )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /*
   * @description: 场景轮巡播放
   * @param { int }  groupId 当前场景轮巡id
   * @param { EditProvider }  editProvider 当前编辑EditProvider
   */
  presetGroupPoll(groupId, EditProvider editProvider) async {
    bool enable = !(groupId == editProvider.currentScreen?.presetPoll?.presetGroupId && editProvider.currentScreen?.presetPoll?.enable == 1);
    int enableVal = enable ? 1: 0;
    var data = {
      'deviceId': 0,
      'screenId': editProvider.currentScreenId,
      'presetGroupId': groupId,
      'enable': enableVal
    };
    // PresetPoll presPoll = PresetPoll(
    //   enable: enableVal,
    //   presetGroupId: groupId
    // );
    // 场景轮巡loading
    EasyLoading.show(status: 'loading...');
    EasyLoading.instance ..maskType =  EasyLoadingMaskType.clear;
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.PRESET_POLL, data: data).then((res) {
      if (res.code == 0) {
        // editProvider.currentScreen.presetPoll = presPoll;
        // editProvider.forceUpdate();
        getPresetPoll(editProvider);
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  /*
   * @description: 读取场景轮巡
   * @param { EditProvider }  editProvider 当前编辑EditProvider
   */
  Future getPresetPoll(EditProvider editProvider) async {
    var data = {
      'deviceId': 0,
      'screenId': editProvider.currentScreenId
    };
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.READ_PRESET_POLL, data: data).then((res) {
      if(res.code == 0) {
        ScreenModel presScreen = editProvider.screenList?.firstWhere(
          (element) => element.screenId == res.data['screenId'],
          orElse: () => null
        );
        presScreen.presetPoll = PresetPoll(
          enable: res.data['enable'],
          presetGroupId: res.data['presetGroupId']
        );
        if (res.data['enable'] == 1) {
          getFirstLayers(editProvider.currentScreenId,res.data['presetGroupId']);
        }
        editProvider.forceUpdate();
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }
  /*
   * @description: 根据场景组presetGroupId获取当前场景组下第一个场景里的图层
   * @param { int } screenId 当前屏幕id
   * @param { int } presetGroupId 场景组id
   */
  getFirstLayers(int screenId, int presetGroupId){
    var presetGroupList = Provider.of<PresetGroupProvider>(context, listen: false).presetGroupList;
    PresetGroup find = presetGroupList.firstWhere((p) => p.presetGroupId == presetGroupId, orElse:()=> null);
    if(find != null && find.presets != null && find.presets.length > 0){
      List<ScreenLayer> layers = find.presets[0].layers;
      loadLayersToScreen(layers, screenId);
    }
  }

  /*
   * @description: 将得到的图层加载到指定的屏幕图层列表里
   * @param { List } layers 指定场景图层列表
   * @param { int } sid 屏幕id
   */
  loadLayersToScreen(List<ScreenLayer> layers, int sid){
    List<ScreenLayer> layerList = List<ScreenLayer>();
    layers?.forEach((element) {
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

    Provider.of<EditProvider>(context, listen: false)
        .screenList
        .firstWhere((element) => element.screenId == sid, orElse: () => null)
        .screenLayers = layerList;
    Provider.of<EditProvider>(context, listen: false).forceUpdate();
    Provider.of<PresetProvider>(context, listen: false).forceUpdate();
  }
  // 防抖
  Function debounce(Function fn, [int t = 1000]) {
    Timer _debounce;
    return () {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(Duration(milliseconds: t), () {
        fn();
      });
    };
  }
}