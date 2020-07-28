import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/api/websocket/index.dart';
import 'package:h_pad/api/websocket/socketData.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/layer_helper.dart';
import 'package:h_pad/common/resource_calculation.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/models/edit/InputListModel.dart';
import 'package:h_pad/models/edit/OutputListModel.dart';
import 'package:h_pad/models/edit/ScreenListModel.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/states/device/deviceProvider.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:h_pad/states/edit/GestureTemplate.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/LayerProvider.dart';
import 'package:h_pad/states/edit/LayerTipProvider.dart';
import 'package:h_pad/states/edit/OutputProvider.dart';
import 'package:h_pad/states/edit/PresetProvider.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:h_pad/views/Edit/inputList/InputTemplate.dart';
// import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/common/resource_calc.dart';

import 'EditHeaderView.dart';
import 'EditMainView.dart';
import 'PresetView.dart';
import 'inputList/InputListView.dart';
import 'package:h_pad/video/videoplayer.dart';
import 'package:h_pad/video/videoparam.dart';

class EditView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DeviceDetailProvider()),
          ChangeNotifierProvider(create: (context) => InputProvider()),
          ChangeNotifierProvider(create: (context) => OutputProvider()),
          ChangeNotifierProvider(create: (context) => PresetProvider()),
          ChangeNotifierProvider(create: (context) => PresetGroupProvider()),
          ChangeNotifierProvider(create: (context) => RenderBoxProvider()),
          ChangeNotifierProvider(create: (context) => GestureTemplateProvider()),
          ChangeNotifierProvider(create: (context) => LayerProvider()),
          ChangeNotifierProvider(create: (context) => LayerTipProvider()),
          ChangeNotifierProvider(create: (context) => VideoProvider()),
          ChangeNotifierProvider(create: (context) => VideoState()),
        ],
        child: Layout(),
      ),
    );
  }
}

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with WidgetsBindingObserver {
  // bool logOutVisible = true;
  bool hideMask = true;
  GlobalKey _editContainerKey = GlobalKey();
  GlobalKey _editRegionKey = GlobalKey();
  GlobalKey _inputRegionKey = GlobalKey();
  static int defaultW = 960;
  static int defaultH = 540;
  WebSocketUtil socketUtil = WebSocketUtil.getInstance();
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
  // CustomerLayer replaceInputItem = null;
  // LoadingDialog loadingDialog;



  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback(_getRenderBox);
    WidgetsBinding.instance.addObserver(this);
    // 打开websocket
    socketUtil.closeManual(true);
    socketUtil.open(Global.getWSUrl);
    socketUtil.registerDataCallback(SocketData(context).onReceiveData);

    getEchoUrl(context);
    // Global.setVideoUrl("rtsp://192.168.10.222:8554/video");
    super.initState();
  }
  //监控页面生命周期
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // app显示后, 刷新状态
    if (state == AppLifecycleState.resumed) {
      // 刷新代码
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  void dispose() {
    // 关闭websocket
    socketUtil.closeManual(true);
    WidgetsBinding.instance.removeObserver(this);
    print('编辑页面dispose');
    sdk.stopCutTask();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: Utils.setFontSize(14),
        ),
        child: Container(
          key: _editContainerKey,
          width: Utils.setWidth(LayoutConstant.UILayoutWidth),
          height: Utils.setHeight(LayoutConstant.UILayoutHeight),
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                height: Utils.setHeight(LayoutConstant.HeadHeight),
                child: EditHeaderView(socketUtil),
              ),
              // (Consumer<EditProvider>(builder: (BuildContext context, data, Widget child) {
              //   return EditHeaderView(temp); //changeLogoutVisible: _logoutVisible
              // }))),
              Container(
                height: Utils.setHeight(LayoutConstant.MainHeight),
                margin: EdgeInsets.only(top: Utils.setHeight(LayoutConstant.HeadHeight)), // 54
                child: Stack(
                  children: <Widget>[
                    // 场景
                    Container(
                        width: Utils.setWidth(LayoutConstant.PresetListWidth), // 156
                        // child: (Consumer<EditProvider>(builder: (BuildContext context, data, Widget child) {
                        //   return PresetView();
                        // }))),
                        child: PresetView()),
                    // 编辑操作区 + 输入列表
                    Positioned(
                        child: Container(
                            margin: EdgeInsets.only(left: Utils.setWidth(LayoutConstant.PresetListWidth)),
                            width: Utils.setWidth(LayoutConstant.MainWidth),
                            child: Container(
                                child: Column(
                              children: <Widget>[
                                // 编辑操作区
                                Container(
                                  key: _editRegionKey,
                                  height: Utils.setHeight(LayoutConstant.EditHeight),
                                  child: EditMainView(),
                                ),
                                // 输入列表
                                Container(
                                  key: _inputRegionKey,
                                  height: Utils.setHeight(LayoutConstant.InputListHeight),
                                  child: new InputListView(
                                      dragDown: onInputDragStart,
                                      dragUpdate: onInputDragUpdate,
                                      dragEnd: onInputDragEnd),

                                  //EditInputView(),
                                )
                              ],
                            )))),
                    // 场景轮巡遮罩
                    Positioned(
                        child: (Consumer2<EditProvider, PresetGroupProvider>(
                            builder: (BuildContext context, data1, data2, Widget child) {
                      return Offstage(
                          offstage: data1.currentScreenId == -1 ||
                              data1.currentScreen?.presetPoll?.enable == 0 ||
                              data1.currentScreen?.presetPoll?.enable == null,
                          child: _presetPollMask(data1, data2));
                    }))),
                  ],
                ),
              ),
              //手势开窗框线
              Consumer<GestureTemplateProvider>(builder: (BuildContext context, data, Widget child) {
                return Positioned(
                  top: data.templateTop,
                  left: data.templateLeft,
                  child: Offstage(
                    offstage: data.isTemplateVisible,
                    child: new InputTemplate(
                      height: data.templateHeight,
                      width: data.templateWidth,
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  // 场景轮巡遮罩
  Widget _presetPollMask(editProvider, presetGroupProvider) {
    // print('${editProvider.screenList.length || editProvider.currentScreen?.presetPoll?.enable == 0}');
    // print('${editProvider.currentScreen?.presetPoll?.enable}');
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: Utils.setWidth(LayoutConstant.PresetListWidth)),
        color: ColorMap.mask_preset_poll_color,
        child: SizedBox(
          height: Utils.setHeight(200),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: Utils.setHeight(15)),
                child: Image.asset(
                  'assets/images/edit/icon_lock.png',
                  width: Utils.setWidth(54),
                  height: Utils.setHeight(54),
                ),
              ),
              Text("${_getPresetPollName(editProvider, presetGroupProvider)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorMap.splitScreen_text_color, fontSize: Utils.setFontSize(16)))
            ],
          ),
        ));
  }

  // 获取当前屏幕正在轮巡的场景名称
  _getPresetPollName(editProvider, presetGroupProvider) {
    String presetPollName = '场景轮巡中';
    presetGroupProvider.presetGroupList.forEach((presetGroup) {
      if (presetGroup.presetGroupId == editProvider.currentScreen?.presetPoll?.presetGroupId) {
        presetPollName = presetGroup?.name;
      }
    });
    return presetPollName;
  }

  //输入源按下PointerDownEvent
  onInputDragStart(DragStartDetails e) {
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    if (editProvider.currentScreenId == -1 ||
        editProvider.currentScreen.freeze.enable == 1 ||
        editProvider.currentScreen.isLock == 1) return;
    //打印手指按下的位置(相对于屏幕)
    ScreenModel currentScreen = Provider.of<EditProvider>(context, listen: false).currentScreen;
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);

    double radioW = renderBoxProvider.getRatioW(currentScreen?.outputMode?.size?.width);
    double radioH = renderBoxProvider.getRatioH(currentScreen?.outputMode?.size?.height);

    double w = defaultW * radioW;
    double h = defaultH * radioH;

    GestureTemplateProvider templateProvider = Provider.of<GestureTemplateProvider>(context, listen: false);
    templateProvider.templateLeft = e.globalPosition.dx;
    templateProvider.templateTop = e.globalPosition.dy;
    templateProvider.templateHeight = h;
    templateProvider.templateWidth = w;
  }

  //输入源移动PointerMoveEvent
  onInputDragUpdate(DragUpdateDetails e) {
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    if (editProvider.currentScreenId == -1 ||
        editProvider.currentScreen.freeze.enable == 1 ||
        editProvider.currentScreen.isLock == 1) return;
    //当前屏幕
    ScreenModel currentScreen = Provider.of<EditProvider>(context, listen: false).currentScreen;
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
    // RenderBox editRegionBox = _editRegionKey.currentContext.findRenderObject();
    // Offset editRegionOffset = editRegionBox.localToGlobal(Offset.zero);
    Offset editRegionOffset = renderBoxProvider.editRenderBoxOffset;
    GestureTemplateProvider templateProvider = Provider.of<GestureTemplateProvider>(context, listen: false);
    //输入源区;
    RenderBox inputRegionBox = _inputRegionKey.currentContext.findRenderObject();
    Offset inputRegionOffset = inputRegionBox.localToGlobal(Offset.zero);
    //分屏操作区
    Offset splitRegionOffset = renderBoxProvider.splitRenderBoxOffset;

    double radioW = renderBoxProvider.getRatioW(currentScreen?.outputMode?.size?.width);
    double radioH = renderBoxProvider.getRatioH(currentScreen?.outputMode?.size?.height);
    double w = defaultW * radioW;
    double h = defaultH * radioH;
    // print('输入源区-----${inputRegionBox.paintBounds.size}-------$inputRegionOffset');

    var left = e.globalPosition.dx;
    var top = e.globalPosition.dy;
    if (e.globalPosition.dx - editRegionOffset.dx <= 0) {
      left = editRegionOffset.dx;
    } else if (e.globalPosition.dx > splitRegionOffset.dx) {
      left = splitRegionOffset.dx - Utils.setWidth(10);
    }
    // else if (e.globalPosition.dx + w > splitRegionOffset.dx) {
    //   left = splitRegionOffset.dx - w;
    // }
    if (e.globalPosition.dy - editRegionOffset.dy <= 0) {
      top = editRegionOffset.dy;
    } else if (e.globalPosition.dy + h > inputRegionOffset.dy + inputRegionBox.paintBounds.height) {
      top = inputRegionOffset.dy + inputRegionBox.paintBounds.height - h;
    }
    templateProvider.templateLeft = left;
    templateProvider.templateTop = top;
    templateProvider.isTemplateVisible = false;
    CustomerLayer replaceInputItem = findChangeInput(left, top);
    if (replaceInputItem != null) {
      // print('替换，${replaceInputItem.screenLayer?.general?.name}');
      Provider.of<EditProvider>(context, listen: false).flickerLayerId = replaceInputItem.screenLayer.layerId;
    } else {
      // print('开窗');
      Provider.of<EditProvider>(context, listen: false).flickerLayerId = -1;
    }
  }

  //输入源移动结束PointerUpEvent
  onInputDragEnd(DragEndDetails e, InputModel pInputModel, InputCrop pInputCrop) {
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    if (editProvider.currentScreenId == -1 ||
        editProvider.currentScreen.freeze.enable == 1 ||
        editProvider.currentScreen.isLock == 1) return;
    // print(e.velocity);
    GestureTemplateProvider templateProvider = Provider.of<GestureTemplateProvider>(context, listen: false);
    templateProvider.isTemplateVisible = true;
    var item = findChangeInput(templateProvider.templateLeft, templateProvider.templateTop);
    if (item != null) {
      // print('替换，${item.screenLayer?.general?.name}');
      replaceSource(item, pInputModel, pInputCrop);
      Provider.of<EditProvider>(context, listen: false).flickerLayerId = -1;
    } else {
      // print('开窗');
      openLayer(pInputModel, pInputCrop);
    }
  }

  //判断是否切源
  findChangeInput(double left, double top) {
    List<CustomerLayer> customerLayers = Provider.of<LayerProvider>(context, listen: false).customerLayers;
    //屏幕区
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
    Offset screenRegionOffset = renderBoxProvider.screenRenderBoxOffset;
    double relativeLeft = left - screenRegionOffset.dx;
    double relativeTop = top - screenRegionOffset.dy;
    // print('查找--${relativeLeft}---$relativeTop');
    // print('查找--左${customerLayers[0]?.layerPosition?.left}---上${customerLayers[0]?.layerPosition?.top}-----左+宽${customerLayers[0]?.layerPosition?.left + customerLayers[0]?.layerPosition?.width}----上+高${customerLayers[0]?.layerPosition?.height +customerLayers[0]?.layerPosition?.top}');
    var item = customerLayers
        .where((p) =>
            relativeLeft >= p.layerPosition.left &&
            relativeLeft <= p.layerPosition.left + p.layerPosition.width &&
            relativeTop >= p.layerPosition.top &&
            relativeTop <= p.layerPosition.top + p.layerPosition.height)
        .toList();
    if (item.length == 0) return null;
    return item[item.length - 1];
  }

  replaceSource(CustomerLayer replaceInputItem, InputModel pInputModel, InputCrop pInputCrop) async {
    ScreenModel currentScreen = Provider.of<EditProvider>(context, listen: false).currentScreen;
    EditProvider editProvider =  Provider.of<EditProvider>(context, listen: false);
    var curLayer = currentScreen.screenLayers.firstWhere((layer) => layer.layerId == replaceInputItem.screenLayer.layerId, orElse: ()=>null);
    List layerInfo = [
      {
        'id':curLayer.layerId,
        'x': curLayer.window.x,
        'y': curLayer.window.y,
        'w': curLayer.window.width,
        'h': curLayer.window.height,
        'connectCapacity': pInputModel.general.connectCapacity
        }
    ];
    bool isOver = ResourceCalc.calcResource(editProvider.screenList, editProvider.currentScreenId, layerInfo);
    if(isOver) return;

    Map params = {
      'deviceId': 0,
      'screenId': currentScreen.screenId,
      'layerId': replaceInputItem.screenLayer.layerId,
      'sourceType': 1, //pInputModel.iSignal,
      "inputId": pInputModel.inputId,
      "cropId": pInputCrop == null ? 255 : pInputCrop.cropId
    };
    try {
      HttpUtil http = HttpUtil(context).getInstance();
      final res = await http.request(Api.WRITE_LAYER_SOURCE, data: params);
      // print('参数---$params');
      if (res.code != 0) return;
      int layerIndex = currentScreen.screenLayers.indexWhere((p) => p.layerId == replaceInputItem.screenLayer.layerId);
      if (layerIndex != -1) {
        LayerSource source = new LayerSource(
          connectCapacity: pInputModel.general.connectCapacity,
          cropId: pInputCrop == null ? 255 : pInputCrop.cropId,
          inputId: pInputModel.inputId,
          interfaceType: currentScreen.screenLayers[layerIndex].source.interfaceType,
          modelId: currentScreen.screenLayers[layerIndex].source.modelId,
          name: pInputCrop == null ? pInputModel.general.name : pInputCrop.name,
          sourceType: 1,
        );
        Provider.of<EditProvider>(context, listen: false).currentScreen.screenLayers[layerIndex].source = source;
        Provider.of<EditProvider>(context, listen: false).forceUpdate();
        VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
        int type = source?.cropId == 255? 0 : 1;
        int layerId = replaceInputItem.screenLayer.layerId;
        sdk.changeVideoIndexByLayerId(currentScreen.screenId, layerId, source?.inputId, type, pInputCrop?.x, pInputCrop?.y, pInputCrop?.width, pInputCrop?.heigth, pInputModel.resolution?.width,pInputModel.resolution?.height);
      }
    } catch (e) {
      print(e);
    }
  }

  //开窗
  openLayer(InputModel pInputModel, InputCrop pInputCrop) async {
    EditProvider editProvider =  Provider.of<EditProvider>(context, listen: false);
    ScreenModel currentScreen = editProvider.currentScreen;
    GestureTemplateProvider templateProvider = Provider.of<GestureTemplateProvider>(context, listen: false);

    const String _layName = 'Layer';
    int _layNum = 1;
    if (currentScreen?.screenLayers != null) {
      _layNum = currentScreen.screenLayers.length;
    }

    //屏幕与物理屏幕比例
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
    double radioW = renderBoxProvider.getRatioW(currentScreen?.outputMode?.size?.width);
    double radioH = renderBoxProvider.getRatioH(currentScreen?.outputMode?.size?.height);

    //屏幕区
    Offset screenRegionOffset = renderBoxProvider.screenRenderBoxOffset;

    int layerId = creatLayerId(currentScreen?.screenLayers);
    //
    int x = PhyicalAndLogicalConverter.getRealOffsetLeft(
        templateProvider.templateLeft - screenRegionOffset.dx,
        currentScreen?.outputMode?.size?.x,
        radioW); //(templateProvider.templateLeft - screenRegionOffset.dx) / radioW + currentScreen?.outputMode?.size?.x;
    int y = PhyicalAndLogicalConverter.getRealOffsetTop(
        templateProvider.templateTop - screenRegionOffset.dy,
        currentScreen?.outputMode?.size?.y,
        radioH); //(templateProvider.templateTop - screenRegionOffset.dy) / radioH + currentScreen?.outputMode?.size?.y;

    bool isOver = ResourceCalc.calcResource(editProvider.screenList, editProvider.currentScreenId, [{'x': x, 'y': y, 'w': defaultW, 'h': defaultH, 'connectCapacity': pInputModel.general?.connectCapacity}]);
    if(isOver) {
      Provider.of<EditProvider>(context, listen: false).selectedLayerId = -1;
      return;
    }

    Map layerParams = {
      'deviceId': 0,
      'screenId': currentScreen.screenId,
      'layerId': layerId,
      'general': {
        'name': _layName + (_layNum + 1).toString(),
        'zorder': _layNum, //根据 图层数量
        'isFreeze': false,
        'flipType': 0,
        'isBackground': false,
        'sizeType': 0,
        'type': 1,
        'layerId': layerId,
      },
      'source': {
        'sourceType': 1, //pInputModel.iSignal,
        'inputId': pInputModel.inputId,
        'cropId': pInputCrop == null ? 255 : pInputCrop.cropId,
        'interfaceType': pInputModel.interfaceType, // #TODO: 这里 有个严重问题
        'connectCapacity': pInputModel.general.connectCapacity,
        'name': pInputCrop == null ? pInputModel.general.name : pInputCrop.name
      },
      'window': {
        'width': defaultW,
        'height': defaultH,
        'x': x,
        'y': y,
      },
      'lock': {'lock': 0}
    };
    try {
      HttpUtil http = HttpUtil(context).getInstance();
      final res = await http.request(Api.CREATE_LAYER, data: layerParams);
      if (res.code != 0) return;
      final listJson = json.encode(res.data['layers']);
      // print('开窗后图层-----${res.data['layers']}');
      List<dynamic> list = json.decode(listJson);
      List<ScreenLayer> layerList = list.map((value) => new ScreenLayer.fromJson(value)).toList();
      Provider.of<EditProvider>(context, listen: false).currentScreen.screenLayers = layerList;
      Provider.of<EditProvider>(context, listen: false).selectedLayerId = layerId;
      Provider.of<EditProvider>(context, listen: false).forceUpdate();
    } catch (e) {
      print(e);
    }
    // }
  }

  //创建图层ID
  creatLayerId(List<ScreenLayer> screenLayers) {
    if (screenLayers == null) return 0;
    for (int i = 0, len = screenLayers.length; i < len + 1; i++) {
      if (screenLayers.indexWhere((el) => el.layerId == i) == -1) {
        return i;
      }
    }
  }

  // 获取编辑区域大小、宽高
  _getRenderBox(_) {
    try {
      //获取`RenderBox`对象
      RenderBox editRegionRenderBox = _editRegionKey.currentContext?.findRenderObject();
      Provider.of<RenderBoxProvider>(context, listen: false).editRenderBoxOffset =
          editRegionRenderBox?.localToGlobal(Offset(0, 0));
    } catch(e) {
      print('layoutView获取屏幕尺寸错误$e');
      EasyLoading.dismiss();
    }
  }

  //获取屏幕、输入源列表
  void awaitBatchData() {
    if(EasyLoading.instance.key == null){
      EasyLoading.show(status: 'loading...');
      EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    }
    // loadingDialog = new LoadingDialog(context);
    HttpUtil http = HttpUtil(context).getInstance();
    Future.wait([
      http.request(Api.SCREEN_LIST, data: {'deviceId': 0}),
      http.request(Api.INPUT_LIST, data: {'deviceId': 0}),
      // http.request(Api.OUTPUT_LIST, data: {'deviceId': 0}),
    ]).then((List responses) {
      _getScreenList(responses[0]);
      _getInputList(responses[1]);
      // _getOutputList(responses[2]);
    }).catchError((err) {
      print('err: $err');
      EasyLoading.dismiss();
      // if (LoadingDialog.state) {
      //   loadingDialog.dispose();
      // }
    }).whenComplete(() => {
          // if (LoadingDialog.state) {loadingDialog.dispose()}
          // EasyLoading.dismiss()
        });
  }

  /*
  * 获取屏幕列表数据BuildContext context
  */
  void _getScreenList(Result res) async {
    // HttpUtil http = HttpUtil(context).getInstance();
    // final res = await http.request(Api.SCREEN_LIST, data: {'deviceId': 0});
    if (res == null || res.code != 0) {
      EasyLoading.dismiss();
      return;
    }
    final listJson = json.encode(res.data);
    //测试数据
    // final listJson = await rootBundle.loadString('lib/mock/screenArray.json');
    // print('listJson------------:$listJson');

    List<dynamic> list = json.decode(listJson);
    ScreenListInfoModel screenListInfo = ScreenListInfoModel.fromJson(list);
    Provider?.of<EditProvider>(context, listen: false)?.screenList = screenListInfo.screenList;
    var curScreen = Provider?.of<EditProvider>(context, listen: false)?.screenList?.firstWhere((screen) => screen.screenId == Provider?.of<EditProvider>(context, listen: false)?.currentScreenId, orElse: ()=>null);
    // print('----------------${screenListInfo.screenList}');
    if (screenListInfo.screenList.length > 0) {
      Provider?.of<EditProvider>(context, listen: false)?.currentScreenId = curScreen == null?  screenListInfo.screenList[0].screenId : curScreen.screenId;
    }else {
      Provider?.of<EditProvider>(context, listen: false)?.currentScreenId = -1;
      EasyLoading.dismiss();
    }
    if(Provider?.of<EditProvider>(context, listen: false)?.currentScreenId == -1 || Provider?.of<EditProvider>(context, listen: false)?.currentScreen == null){
      EasyLoading.dismiss();
    }
  }

  //获取输入列表数据BuildContext context
  void _getInputList(Result res) async {
    if (res == null || res.code != 0)
      return;
    final listJson = json.encode(res.data);
    List<dynamic> list = json.decode(listJson);
    InputListInfoModel inputListInfo = InputListInfoModel.fromJson(list);
    if (inputListInfo.inputList.length > 0) {
      Provider?.of<InputProvider>(context, listen: false)?.inputList = inputListInfo.inputList;
    }
  }


  //获取输入列表数据BuildContext context
  void _getOutputList(Result res) async {
    if (res == null || res.code != 0)
      return;
    final listJson = json.encode(res.data);
    List<dynamic> list = json.decode(listJson);
    OutputListInfoModel outputListInfo = OutputListInfoModel.fromJson(list);
    if (outputListInfo.outputList.length > 0) {
      Provider.of<OutputProvider>(context, listen: false).outputList = outputListInfo.outputList;
    }
  }

  // 执行切割任务
  executeCutTask(url) {
    bool isVideoClosed = Provider.of<VideoState>(context,listen: false).isVideoClosed == null? false : Provider.of<VideoState>(context,listen:false).isVideoClosed;
    VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
    sdk.init(context);
    if (!isVideoClosed) {
      sdk.createCutTask(new VideoParam(url));
    }
  }
  // 获取预监ECHOURL并创建和执行切割
  getEchoUrl(context) async{
    try {
      String url;
      HttpUtil http = HttpUtil(context).getInstance();
      final res = await http.request(Api.READ_DEVICE_DETAIL, data: {'deviceId': 0});
      if (res.code == 0){
        var deviceDetail = json.decode(json.encode(res.data));
        if(deviceDetail['slotList'].length > 0) {
          var mvrCard = deviceDetail['slotList'].firstWhere((slot) => slot['cardType'] == 4, orElse: () => null);
          if(mvrCard != null) {
            final result = await http.request(Api.GET_SLOT_INFO, data: {'deviceId': 0, 'slotId': mvrCard['slotId']});
            if(result.code == 0){
              var mvrUrl = json.decode(json.encode(result.data))['encoding']['mvrUrl'];
              int port = int.parse(mvrUrl.substring(mvrUrl.lastIndexOf(':')+1)) + 10;
              url = 'rtsp' + mvrUrl.substring(mvrUrl.indexOf(':'), mvrUrl.lastIndexOf(':')) + ':' + port.toString() +'/echovideo';
              Future.delayed(Duration(milliseconds:300)).then((e) {
                if (null != url) {
                  executeCutTask(url);
                }
                awaitBatchData();
              });
              Global.setVideoUrl(url);
            }else{
              Future.delayed(Duration(milliseconds:300)).then((e) {
                awaitBatchData();
              });
            }
          }else{
            Future.delayed(Duration(milliseconds:300)).then((e) {
              awaitBatchData();
            });
          }
        }else{
          Future.delayed(Duration(milliseconds:300)).then((e) {
            awaitBatchData();
          });
        }
      }else{
        Future.delayed(Duration(milliseconds:300)).then((e) {
          awaitBatchData();
        });
      }
    } catch (e) {
      print("获得rtsp url时出错！$e");
      Future.delayed(Duration(milliseconds:300)).then((e) {
        awaitBatchData();
      });
    }
  }

}
