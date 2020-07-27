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
  // int _pollPresetId; // 当前播放的场景
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

    // setState(() {
    //   _pollPresetId = presetGroupProvider.pollPresetId;
    // });

    return Container(
      color: ColorMap.input_background,
      height: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: presetGroupProvider.presetGroupList?.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Container(
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
                        ? Image.asset('assets/images/preset/icon_stop.png', width: Utils.setWidth(28), height: Utils.setHeight(28),  color: ColorMap.white)
                        : Image.asset('assets/images/preset/icon_play.png', width: Utils.setWidth(28), height: Utils.setHeight(28),  color: ColorMap.grey),
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
            ),
            Container(
              child: Offstage(
                offstage: !isPoll || !(presetGroupProvider.presetGroupList[index].presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true, 
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: presetGroupProvider.presetGroupList[index].presets.length,
                  itemBuilder: (context, index2) {
                    return Container(
                      height: Utils.setHeight(52),
                      decoration: BoxDecoration(
                        color: ColorMap.input_background_normal,
                        border: Border(
                          top: BorderSide(
                            width: Utils.setWidth(0.5),
                            color: ColorMap.border_color_item
                          ),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            left: Utils.setWidth(18),
                            child: Offstage(
                              // offstage: presetGroupProvider.presetGroupList[index].presets[index2].presetId != _pollPresetId,
                               offstage: presetGroupProvider.presetGroupList[index].presets[index2].presetId != presetGroupProvider.pollPresetId,
                              child: Image.asset('assets/images/preset/icon_indicator_arrow.png', width: Utils.setWidth(16), height: Utils.setHeight(16), color: ColorMap.indicator,),
                            ),
                          ),
                          Positioned(
                            left: Utils.setWidth(38),
                            child: Text(
                              '${presetGroupProvider.presetGroupList[index].presets[index2].name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorMap.white,
                                fontSize: Utils.setFontSize(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ),
          ]);
        },
      ),
    );
  }

  /*
   * @description: 场景轮巡播放
   * @param { int }  groupId 当前场景轮巡id
   * @param { EditProvider }  editProvider 当前编辑EditProvider
   */
  presetGroupPoll(int groupId, EditProvider editProvider) async {
    bool enable = !(groupId == editProvider.currentScreen?.presetPoll?.presetGroupId && editProvider.currentScreen?.presetPoll?.enable == 1);
    int enableVal = enable ? 1 : 0;
    var data = {
      'deviceId': 0,
      'screenId': editProvider.currentScreenId,
      'presetGroupId': groupId,
      'enable': enableVal
    };
    // 场景轮巡loading
    EasyLoading.show(status: 'loading...');
    EasyLoading.instance ..maskType =  EasyLoadingMaskType.clear;
    HttpUtil http = HttpUtil(context).getInstance();
    if(enableVal == 1){
      updateStatus(editProvider, editProvider.currentScreenId, 1, groupId); // 从场景组的第一个场景的图层开始轮巡
    }

    http.request(Api.PRESET_POLL, data: data).then((res) { // 通知设备开启或关闭轮巡
      if (res.code == 0) {
        // if (enableVal == 1) { // 只有开启轮巡的时候才会读取并渲染场景组第一个场景里的图层数据
        //   getPresetPoll(editProvider);
        // //todo:改变场景轮询是否在执行的按钮的状态
        // } else {
        //   EasyLoading.dismiss();
        // }
        getPresetPoll(editProvider, enableVal);//
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  /*
   * @description: 读取场景轮巡
   * @param { EditProvider }  editProvider 当前编辑EditProvider, int enableVal
   */
  Future getPresetPoll(EditProvider editProvider, int enableVal) async {
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
        if(presScreen != null) {
          presScreen.presetPoll = PresetPoll(
            enable: res.data['enable'],
            presetGroupId: res.data['presetGroupId']
          );          
        }
        if(enableVal == 0) {
          freshDeive();
        }
        editProvider.forceUpdate();
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  updateStatus(EditProvider editProvider, int sid, int enable, int presetGroupId) {
    ScreenModel presScreen = editProvider.screenList?.firstWhere(
      (element) => element.screenId == sid,
      orElse: () => null
    );
    presScreen.presetPoll = PresetPoll(
      enable: enable,
      presetGroupId: presetGroupId
    );
    editProvider.forceUpdate();
  }

  freshDeive() {
    var data = {
      'deviceId': 0
    };
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.REFRESH_DEVICE, data: data);
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