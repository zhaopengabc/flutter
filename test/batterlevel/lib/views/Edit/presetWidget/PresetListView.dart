// 场景列表
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/preset/PresetGroupModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/states/edit/PresetProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/common/resource_calc.dart';

class PresetListView extends StatefulWidget {
  @override
  _PresetListViewState createState() => _PresetListViewState();
}

class _PresetListViewState extends State<PresetListView> {

  int isFreeze = 0; // 是否冻结屏幕，0不冻结，1冻结
  int isLock = 0; // 是否锁屏，0不锁屏，1锁屏
  int pollEnable = 0; // 当前屏幕场景轮巡是否进行中
  int currentScreenId = -1; // 当前屏幕id
  int currentPresetId = -1; // 当前场景id
  ScreenModel currentScreen = ScreenModel();
  Preset currentPreset = Preset();

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    PresetProvider presetProvider = Provider.of<PresetProvider>(context);

    currentScreenId = editProvider.currentScreenId;
    currentScreen = editProvider.currentScreen;
    currentPresetId = presetProvider.currentPresetId;
    currentPreset = presetProvider.currentPreset;

    return Container(
      color: ColorMap.input_background,
      height: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: presetProvider.presetList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 6.0, 0, 6.0),
            height: Utils.setHeight(52),
            decoration: BoxDecoration(
              color:
                presetProvider.currentPreset?.presetId == presetProvider.presetList[index].presetId
                ? ColorMap.input_background_normal : ColorMap.input_background,
              border: Border(
                left: BorderSide(
                  width:
                  presetProvider.currentPreset?.presetId == presetProvider.presetList[index].presetId
                  ? Utils.setWidth(1.8) : Utils.setWidth(0.000001),
                  color: ColorMap.orange_selected
                ),
                bottom: BorderSide(
                  width: Utils.setWidth(0.5),
                  color:
                  presetProvider.currentPreset?.presetId == presetProvider.presetList[index].presetId
                  ? ColorMap.input_background_normal : ColorMap.border_color_item
                ),
              )
            ),
            child: MaterialButton(
              minWidth: double.infinity,
              padding: EdgeInsets.only(left: 17.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left:
                    presetProvider.currentPreset?.presetId == presetProvider.presetList[index].presetId
                    ? Utils.setWidth(0.000001) : Utils.setWidth(1.8),
                    child: Text(
                      '${presetProvider.presetList[index].name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                        presetProvider.currentPreset?.presetId == presetProvider.presetList[index].presetId
                        ? ColorMap.white : ColorMap.button_font_color,
                        fontSize: Utils.setFontSize(14),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                // presetProvider.currentPresetId = presetProvider.presetList[index].presetId;
                presetPlay(presetProvider.presetList[index].layers, presetProvider.presetList[index].presetId, editProvider, presetProvider);
              },
            ),
          );
        }
      ),
    );
  }

  /*
   * @description: 调用场景播放接口
   * @param { List } currentPresetLayers当前场景图层列表
   * @param { int } pid 当前选中场景id
   * @param { EditProvider } editProvider 编辑Provider
   * @param { PresetProvider } presetProvider 场景Provider
   */
  presetPlay(List currentPresetLayers, pid, EditProvider editProvider, PresetProvider presetProvider) async {
    bool isOver = ResourceCalc.calcResource(editProvider.screenList, editProvider.currentScreenId, json.decode(json.encode(currentPresetLayers)));
    if(isOver) return;

    // 场景应用前判断冻结、锁屏、轮巡状态
    isFreeze = editProvider.currentScreen?.freeze?.enable;
    isLock = editProvider.currentScreen?.isLock;
    pollEnable = editProvider.currentScreen?.presetPoll?.enable;
    if(currentScreenId == -1 || isFreeze == 1 || isLock == 1 || pollEnable == 1 ) {
      return false;
    }

    presetProvider.currentPresetId = pid;

    var data = {
      'deviceId': 0,
      'screenId': editProvider.currentScreenId,
      'presetId': pid
    };
    // 场景应用loading
    EasyLoading.show(status: 'loading...');
    EasyLoading.instance ..maskType =  EasyLoadingMaskType.black;
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.PRESET_PLAY, data: data).then((res) {
      if (res.code == 0) {
        presetApply(currentPresetLayers, editProvider);
        Fluttertoast.showToast(
          msg: '场景加载成功',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: ColorMap.mask_bkg_color,
          fontSize: Utils.setFontSize(14),
          textColor: ColorMap.white,
          gravity: ToastGravity.CENTER);

      } else {
        EasyLoading.dismiss();
      }
    });
  }

  /*
   * @description: 场景应用
   * @param { Object } pLayers 当前选中场景图层
   * @param { EditProvider } editProvider 编辑Provider
   */
  presetApply(List pLayers, EditProvider editProvider) {
    List<ScreenLayer> layerList = List<ScreenLayer>();
    pLayers.forEach((element) {
      Map layer = {
        "deviceId": 0,
        "layerId": element.general.layerId,
        "lock": { "lock": 0 },
        "screenId": editProvider.currentScreenId,
        "general": element.general,
        "source": element.source,
        "window": element.window
      };
      layerList.add(ScreenLayer.fromJson(json.decode(json.encode(layer))));
    });

    editProvider.currentScreen.screenLayers = layerList;
    editProvider.selectedLayerId = -1;
    editProvider.forceUpdate();
    EasyLoading.dismiss();
  }
}
