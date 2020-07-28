import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:h_pad/api/api.dart';
import 'package:h_pad/api/http.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/common/resource_calc.dart';

class SplitScreenTemplateView extends StatefulWidget {
  final RenderBoxProvider renderBoxProvider;
  SplitScreenTemplateView(this.renderBoxProvider);
  @override
  _SplitScreenTemplateViewState createState() => _SplitScreenTemplateViewState();
}

class _SplitScreenTemplateViewState extends State<SplitScreenTemplateView> {
  int screenRealW = 100;
  int screenRealH = 200;
  int screenRealX = 0;
  int screenRealY = 0;
  var screenId = 0;
  List inputListData = [];
  var tempContext;
  BuildContext context;
  List screenList = [];
  GlobalKey _splitRegionKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getRenderBox);
    super.initState();
  }

  _getRenderBox(_) {
    //获取`RenderBox`对象
    RenderBox splitRegionRenderBox = _splitRegionKey.currentContext.findRenderObject();
    Offset splitRegionOffset = splitRegionRenderBox.localToGlobal(Offset.zero);
    widget.renderBoxProvider.splitRenderBoxOffset = splitRegionOffset;
    widget.renderBoxProvider.screenRenderBoxSize = _splitRegionKey.currentContext.size;
  }

  int tempNum = -1;
  bool isDown = false; // 是否按下分屏按钮
  bool isClearPressed = false; // 是否按下清除按钮

  @override
  Widget build(BuildContext context) {
    tempContext = context;
    EditProvider editProvider = Provider.of<EditProvider>(context);
    if (editProvider.currentScreen != null &&
        editProvider.currentScreen.outputMode != null &&
        editProvider.currentScreen.outputMode.size != null) {
      screenRealW = editProvider.currentScreen.outputMode.size.width;
      screenRealH = editProvider.currentScreen.outputMode.size.height;
      screenRealX = editProvider.currentScreen.outputMode.size.x;
      screenRealY = editProvider.currentScreen.outputMode.size.y;
      screenId = editProvider.currentScreen.screenId;
      // print('屏幕宽高：-----------------------:${screenRealW} ${screenRealH}');
    }
    screenList = editProvider.screenList;
    InputProvider inputProvider = Provider.of<InputProvider>(context);
    // print('inputProvider: ${inputProvider}, inputProvider.inputList ${inputProvider.inputList}');
    if (inputProvider.inputList != null) {
      inputListData = [];
      var inputList = inputProvider.inputList.where((p)=>p.online!=0);//inputProvider.inputList;
      // 筛选出连接容量为1的输入
      inputList.forEach((input) {
        if (input.general != null && input.general.connectCapacity == 0) {
          inputListData.add(input);
        }
      });
    }

    return Container(
      key: _splitRegionKey,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Text('分屏模板')
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: isDown && tempNum == 1 ? ColorMap.press_bkg_color : Colors.transparent,
                  padding: EdgeInsets.only(bottom: Utils.setHeight(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(10), 0, Utils.setHeight(10)),
                        child: Image.asset('assets/images/edit/icon_screen1_normal.png',
                            fit: BoxFit.contain, width: Utils.setWidth(36), height: Utils.setHeight(36)),
                      ),
                      Text('全屏', textAlign: TextAlign.center, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                    ],
                  ),
                ),
                onTapDown: (d) {
                  selectSplitScreenTemplateTap(1);
                  setState(() => this.isDown = true);
                },
                onTapUp: (d) => setState(() => this.isDown = false),
                onTapCancel: () => setState(() => this.isDown = false),
              ),
              GestureDetector(
                child: Container(
                    color: isDown && tempNum == 2 ? ColorMap.press_bkg_color : Colors.transparent,
                    padding: EdgeInsets.only(bottom: Utils.setHeight(10)),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(10), 0, Utils.setHeight(10)),
                        child: Image.asset('assets/images/edit/icon_screen2_normal.png',
                            fit: BoxFit.contain, width: Utils.setWidth(36), height: Utils.setHeight(36)),
                      ),
                      Text('二分屏',
                          textAlign: TextAlign.center, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                    ])),
                onTapDown: (d) {
                  selectSplitScreenTemplateTap(2);
                  setState(() => this.isDown = true);
                },
                onTapUp: (d) => setState(() => this.isDown = false),
                onTapCancel: () => setState(() => this.isDown = false),
              ),
              GestureDetector(
                child: Container(
                    color: isDown && tempNum == 4 ? ColorMap.press_bkg_color : Colors.transparent,
                    padding: EdgeInsets.only(bottom: Utils.setHeight(10)),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(10), 0, Utils.setHeight(10)),
                        child: Image.asset('assets/images/edit/icon_screen4_normal.png',
                            fit: BoxFit.contain, width: Utils.setWidth(36), height: Utils.setHeight(36)),
                      ),
                      Text('四分屏',
                          textAlign: TextAlign.center, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                    ])),
                onTapDown: (d) {
                  selectSplitScreenTemplateTap(4);
                  setState(() => this.isDown = true);
                },
                onTapUp: (d) => setState(() => this.isDown = false),
                onTapCancel: () => setState(() => this.isDown = false),
              ),
              GestureDetector(
                child: Container(
                    color: isDown && tempNum == 6 ? ColorMap.press_bkg_color : Colors.transparent,
                    padding: EdgeInsets.only(bottom: Utils.setHeight(10)),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(10), 0, Utils.setHeight(10)),
                        child: Image.asset('assets/images/edit/icon_screen6_normal.png',
                            fit: BoxFit.contain, width: Utils.setWidth(36), height: Utils.setHeight(36)),
                      ),
                      Text('六分屏',
                          textAlign: TextAlign.center, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                    ])),
                onTapDown: (d) {
                  selectSplitScreenTemplateTap(6);
                  setState(() => this.isDown = true);
                },
                onTapUp: (d) => setState(() => this.isDown = false),
                onTapCancel: () => setState(() => this.isDown = false),
              ),
              GestureDetector(
                child: Container(
                    color: isDown && tempNum == 9 ? ColorMap.press_bkg_color : Colors.transparent,
                    padding: EdgeInsets.only(bottom: Utils.setHeight(10)),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(10), 0, Utils.setHeight(10)),
                        child: Image.asset('assets/images/edit/icon_screen9_normal.png',
                            fit: BoxFit.contain, width: Utils.setWidth(36), height: Utils.setHeight(36)),
                      ),
                      Text('九分屏',
                          textAlign: TextAlign.center, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                    ])),
                onTapDown: (d) {
                  selectSplitScreenTemplateTap(9);
                  setState(() => this.isDown = true);
                },
                onTapUp: (d) => setState(() => this.isDown = false),
                onTapCancel: () => setState(() => this.isDown = false),
              ),
            ],
          ),
          Positioned(
            left: Utils.setWidth(0),
            bottom: Utils.setHeight(0),
            child: Container(
              color: isClearPressed ? ColorMap.press_bkg_color : Colors.transparent,
              height: Utils.setHeight(48),
              width: Utils.setWidth(71),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                GestureDetector(
                  child: Image.asset('assets/images/edit/icon_clear_normal.png',
                      width: Utils.setWidth(30), height: Utils.setHeight(30)),
                  onTapDown: (d) {
                    clearLayer();
                    setState(() => this.isClearPressed = true);
                  },
                  onTapUp: (d) => setState(() => this.isClearPressed = false),
                  onTapCancel: () => setState(() => this.isClearPressed = false),
                ),
                  GestureDetector(
                  child: Container(
                    child: Text('清除', textAlign: TextAlign.right, style: TextStyle(color: ColorMap.splitScreen_text_color)),
                  ),
                  onTapDown: (d) {
                    clearLayer();
                    setState(() => this.isClearPressed = true);
                  },
                  onTapUp: (d) => setState(() => this.isClearPressed = false),
                  onTapCancel: () => setState(() => this.isClearPressed = false),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  /*
  * @description : 选择分屏模板
  * @param { int }index-当前模板编号
  */
  selectSplitScreenTemplateTap(index) {
    if (inputListData.length > 0 && screenList.length > 0) {
      tempNum = index;
      // 遮罩打开
      // showLoadingDialog(tempContext);
      EasyLoading.show(status: 'loading...');
      EasyLoading.instance..maskType = EasyLoadingMaskType.black;
      createLayerBatch(tempNum);
    }
  }

  // 清空图层
  clearLayer() async {
    if (screenList.length > 0) {
      // showLoadingDialog(tempContext);
      HttpUtil http = HttpUtil(context).getInstance();
      var res = await http.request(Api.DELETE_LAYER_BATCH, data: {'deviceId': 0, 'screenId': screenId, 'model': 0});
      if (res.code == 0) {
        getCurScreenDetail();
      }
    }
  }

  /*
  * @description : 批量创建图层
  * @param { int }tempNum-当前模板编号
  */
  createLayerBatch(tempNum) {
    List inputList = inputListData;
    var lang = 'en'; // TODO 获取语言模式
    int screenW = screenRealW;
    int screenH = screenRealH;
    List layerList = List();
    // 整理批量创建图层调用接口参数
    Map params = {'screenId': screenId, 'deviceId': 0, 'layers': layerList};
    int totalLayers = tempNum;
    // totalLayers = totalLayers > inputList.length ? inputList.length : totalLayers;
    int inputTotal = inputList.length;
    for (var i = 0; i < totalLayers; i++) {
      // if(i == 0) continue;
      String name = lang == 'en' ? "Layer ${i + 1}" : "图层 ${i + 1}";
      Map layerInfo = {
        'layerId': i,
        'screenId': Provider.of<EditProvider>(tempContext, listen: false).currentScreenId,
        'general': {
          'name': name,
          'zorder': i,
          'isFreeze': false,
          'flipType': 0,
          'isBackground': false,
          'sizeType': 0,
          'type': 1,
          'layerId': i,
        },
        'source': {
          'sourceType': 1,
          'inputId': inputList[i % inputTotal].inputId,
          'cropId': 255,
          'interfaceType': inputList[i % inputTotal].interfaceType,
          'connectCapacity': inputList[i % inputTotal].general.connectCapacity,
          'name': inputList[i % inputTotal].general.name
        },
        'window': {'width': screenW, 'height': screenH, 'x': screenRealX, 'y': screenRealY},
        'lock': {'lock': 0},
        'deviceId': 0
      };

      if (tempNum == 2) {
        // 二分屏
        layerInfo['window'] = {'width': screenW / 2, 'height': screenH, 'x': screenRealX, 'y': screenRealY};
        if (i == 1) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
        }
      } else if (tempNum == 4) {
        // 四分屏
        layerInfo['window'] = {'width': screenW / 2, 'height': screenH / 2, 'x': screenRealX, 'y': screenRealY};
        if (i == 1) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
        } else if (i == 2) {
          layerInfo['window']['y'] = screenH / 2 + screenRealY;
        } else if (i == 3) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
          layerInfo['window']['y'] = screenH / 2 + screenRealY;
        }
      } else if (tempNum == 6) {
        // 六分屏
        layerInfo['window'] = {'width': screenW / 2, 'height': screenH / 3, 'x': screenRealX, 'y': screenRealY};
        if (i == 1) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
        } else if (i == 2) {
          layerInfo['window']['y'] = screenH / 3 + screenRealY;
        } else if (i == 3) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 + screenRealY;
        } else if (i == 4) {
          layerInfo['window']['y'] = screenH / 3 * 2 + screenRealY;
        } else if (i == 5) {
          layerInfo['window']['x'] = screenW / 2 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 * 2 + screenRealY;
        }
      } else if (tempNum == 9) {
        // 九分屏
        layerInfo['window'] = {'width': screenW / 3, 'height': screenH / 3, 'x': screenRealX, 'y': screenRealY};
        if (i == 1) {
          layerInfo['window']['x'] = screenW / 3  + screenRealX;
        } else if (i == 2) {
          layerInfo['window']['x'] = screenW / 3 * 2 + screenRealX;
        } else if (i == 3) {
          layerInfo['window']['y'] = screenH / 3 + screenRealY;
        } else if (i == 4) {
          layerInfo['window']['x'] = screenW / 3 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 + screenRealY;
        } else if (i == 5) {
          layerInfo['window']['x'] = screenW / 3 * 2 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 + screenRealY;
        } else if (i == 6) {
          layerInfo['window']['y'] = screenH / 3 * 2 + screenRealY;
        } else if (i == 7) {
          layerInfo['window']['x'] = screenW / 3 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 * 2 + screenRealY;
        } else if (i == 8) {
          layerInfo['window']['x'] = screenW / 3 * 2 + screenRealX;
          layerInfo['window']['y'] = screenH / 3 * 2 + screenRealY;
        }
      }
      layerList.add(layerInfo);
    }
    // print(params);
    // print(layerList);
    EditProvider editProvider =  Provider.of<EditProvider>(tempContext, listen: false);
    bool isOver = ResourceCalc.calcResource(editProvider.screenList, editProvider.currentScreenId, layerList);
    if(isOver) {
      EasyLoading.dismiss();
      return;
    }
    createLayerBatchInterface(params);
  }

  // 批量开窗调接口
  createLayerBatchInterface(params) async {
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.CREATE_LAYER_BATCH, data: params).then((res) {
      if (res.code != 0) {
        // Navigator.of(tempContext).pop(); //关闭遮罩层
        EasyLoading.dismiss();
      } else {
        getCurScreenDetail();
      }
    }).catchError((e) {
      // Navigator.of(tempContext).pop(); //关闭遮罩层
      EasyLoading.dismiss();
      throw e;
    });
  }

  // 获取屏幕详情并更新当前屏幕数据
  getCurScreenDetail() async {
    HttpUtil http = HttpUtil(context).getInstance();
    http.request(Api.GET_SCREEN_DETAIL, data: {'deviceId': 0, 'screenId': screenId}).then((res) {
      if(res.code == 0) {
        // print('模板开窗后的图层-----${res.data['screenLayers']}');
        final screenJson = json.encode(res.data);
        var screenInfo = json.decode(screenJson);

        // 更新屏幕列表数据
        EditProvider editProvider = Provider.of<EditProvider>(tempContext, listen: false);

        // for (var i = 0; i < editProvider.screenList.length; i++) {
        //   if (editProvider.screenList[i].screenId == screenId) {
        //     // editProvider.currentScreen = ScreenModel.fromJson(screenInfo);
        //     editProvider.screenList[i] = ScreenModel.fromJson(screenInfo);
        //     editProvider.forceUpdate();
        //   }
        // }
        int index = editProvider.searchScreenIndexById(screenId);
        if(index != -1){
          editProvider.screenList[index] = ScreenModel.fromJson(screenInfo);
          editProvider.selectedLayerId = -1;
          editProvider.forceUpdate();
        }
      }
    }).whenComplete(() {
      // Navigator.of(tempContext).pop(); //关闭遮罩层
      EasyLoading.dismiss();
    });
  }

  test(EditProvider editProvider) async {
    //测试数据
    final listJson = await rootBundle.loadString('lib/mock/screenDetail.json');
    // print('listJson------------:${listJson.runtimeType}');
    // final screenJson = json.encode(listJson);
    var screenInfo = json.decode(listJson);
    ScreenModel sm = new ScreenModel.fromJson(screenInfo);
    editProvider.updateScreenModel(sm);
  }
}
