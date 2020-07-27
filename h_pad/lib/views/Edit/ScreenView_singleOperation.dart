// 屏幕部分

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/CustomerSizeChangedLayoutNotifier.dart';
import 'package:h_pad/common/layer_helper.dart';
import 'package:h_pad/models/edit/ScreenListModel.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';
import 'package:h_pad/models/screen/OutPutModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/models/video/videoModel.dart';
import 'package:h_pad/states/common/ProfileChangeNotifier.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/LayerProvider.dart';
import 'package:h_pad/states/edit/LayerTipProvider.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:flutter/rendering.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/video/videoplayer.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';

class ScreenView extends StatefulWidget {
  // final EditProvider editProvider;
  // ScreenView(this.editProvider);
  @override
  _ScreenViewState createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView>  with TickerProviderStateMixin, WidgetsBindingObserver{
  double screenWidthBlank = (LayoutConstant.UILayoutWidth -
          LayoutConstant.PresetListWidth -
          LayoutConstant.SplitScrernWidth -
          30 * 2)
      .toDouble(); // 空白区域宽
  double screenHeightBlank = (LayoutConstant.UILayoutHeight -
          LayoutConstant.HeadHeight -
          LayoutConstant.InputListHeight -
          LayoutConstant.ActionBtnHeight -
          30 * 2)
      .toDouble(); // 空白区域高
  double screenWidth = 0;
  double screenHeight = 0;
  int screenRealW = 0;
  int screenRealH = 0;
  int screenRealX = 0;
  int screenRealY = 0;
  double scale = 1;
  List<Widget> layerList = [];
  List<Widget> outputModeList = [];
  List screenInterfaces;
  var bkgEnable = 0;
  double xDis = 0; //鼠标点击point距屏幕左上角的offsetLeft
  double yDis = 0; //鼠标点击point距屏幕左上角的offsetTop
  double _preWidth = 0; //缩放之前图层的宽度
  double _preHeight = 0; //缩放之前图层的高度
  double _startX = 0; //拖拽开始时鼠标的位置x
  double _startY = 0; //拖拽开始时鼠标的位置y
  double _startLeft = 0; //拖拽开始时图层左上角的位置x
  double _startTop = 0; //拖拽开始时图层左上角的位置y
  bool isDraging = false;
  int _dragType = -1; //1: 向左拖动；2：向右拖动

  GlobalKey _screenRegionKey = GlobalKey();
  AnimationController controller;
  double preVscale = 0.0;
  double preHscale = 0.0;
  // Animation<RelativeRect> animationTest;
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
  static const double layerTipMaxWidth = 180; // 当前用户操作提示框最大宽度
  static const double layerOperationBtnWidth = 32; //图层操作的四个圈的宽度
  static const double layerHeaderHeight = 48; //图层header高度
  static const double layerMinWidth = 64;
  static const double layerMinHeight = 64;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didChangeDependencies();
  }
 
  @override
  void didUpdateWidget(oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didUpdateWidget(oldWidget);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // app显示后, 刷新状态
    if (state == AppLifecycleState.resumed) {
      // 刷新代码
      SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    }
    if (state == AppLifecycleState.paused) {
      // app退到后台后, 刷新状态
      SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    }
    if (state == AppLifecycleState.inactive) {
      // app退到后台后, 刷新状态
      SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    }
    if (state == AppLifecycleState.detached) {
      // app退到后台后, 刷新状态
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    return NotificationListener<LayoutChangedNotification>(
      onNotification: (notification) {
        /// 收到布局结束通知,打印尺寸
        /// flutter1.7之后需要返回值,之前是不需要的.
        _printSize();
        return null;
      },
      child: CustomerSizeChangedLayoutNotifier(
        child: GestureDetector(
          child: Container(
            width: Utils.setWidth(LayoutConstant.EditWidth),
            height: Utils.setHeight(LayoutConstant.EditHeight),
            alignment: Alignment.center,
            color: ColorMap.screen_bkg_color,
            child: Consumer<EditProvider>(
              builder: (BuildContext context, data, Widget child) {
                screenRealW = data.currentScreenRealWidth ?? 0;
                screenRealH = data.currentScreenRealHeight ?? 0;
                screenRealX = data.currentScreenRealX ?? 0;
                screenRealY = data.currentScreenRealY ?? 0;
                screenWidth = data.getCurrentScreenWidth(screenWidthBlank, screenHeightBlank) ?? 0.0;
                screenHeight = data.getCurrentScreenHeight(screenWidthBlank, screenHeightBlank) ?? 0.0;
                bkgEnable = data.bkgEnable ?? 0;
                scale = data.currentScreenScale ?? 1.0;
                 Future.delayed(Duration(milliseconds: 0)).then((e) {
                  generatCustomerLayer();
                });
              return 
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  // color: Colors.blue,
                  width: Utils.setWidth(LayoutConstant.EditWidth),
                  height: Utils.setHeight(LayoutConstant.EditHeight),
                  padding: EdgeInsets.only(bottom: Utils.setHeight(74)),
                  alignment: Alignment.center,
                  child: Container(
                    key: _screenRegionKey,
                    width: Utils.setWidth(screenWidth),
                    height: Utils.setHeight(screenHeight),
                    // color: Colors.black,//ColorMap.screen_color,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: bkgWidget(bkgEnable == 1),
                        ),
                        Container(
                          child: outputModeListWidget(data //widget.editProvider
                              .currentScreen?.outputMode?.screenInterfaces),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: ColorMap.black,
                      border:
                          Border.all(width: 1.0, 
                          color: ColorMap.screen_border_color,//ColorMap.screen_color,
                    )),
                  ),
              ),
              
              // 图层容器的宽高为编辑区宽高，为了解决layer超出stack区域时，拖动layer感应不到手势的问题
              Container(
                width: Utils.setWidth(LayoutConstant.EditWidth),
                height: Utils.setHeight(LayoutConstant.EditHeight),
                color: Colors.transparent,//ColorMap.screen_color,
                child: Consumer2<LayerProvider, RenderBoxProvider>(
                        builder: (BuildContext context, data1, data2, Widget child) {
                      return Container(
                        // color: Colors.green,
                        child: layerListWidget(),
                      );
                    }),
                ),
              ],);
            }),
            ),
          )
      ),
    );
  }

//图层stack
  Widget layerListWidget() {
    List<CustomerLayer> customerLayers =
        Provider.of<LayerProvider>(context, listen: false).customerLayers;
    Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
    if (customerLayers == null || screenRenderBoxOffset == null) return null;
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in customerLayers) {
      tiles.add(
        Positioned(
          key: Key(item.screenLayer.layerId.toString()),
          left: item.layerPosition.left + Provider.of<RenderBoxProvider>(context, listen: false).screenFromEditLeft - Utils.setWidth(layerOperationBtnWidth/2), 
          top: item.layerPosition.top + Provider.of<RenderBoxProvider>(context, listen: false).screenFromEditTop - Utils.setHeight(layerHeaderHeight) - Utils.setHeight(layerOperationBtnWidth/2),
          child:  Stack(
              overflow: Overflow.visible,
              children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: Utils.setWidth(layerTipMaxWidth)),
                // color: Colors.red,
                padding: EdgeInsets.fromLTRB(Utils.setWidth(layerOperationBtnWidth/2), Utils.setHeight(layerOperationBtnWidth/2), 0, 0),
                child: layerWidget(item),
              ),
              layerFullScreenBtnWidget(item),
              layerCloseBtnWidget(item), //删除、全屏按钮暂时隐藏，使用临时的
              layerDragLeftBtnWidget(item),
              layerDragRightBtnWidget(item)
            ],),
          )
      );
    }
    content = new Container(
      color: Colors.transparent,
      child: Stack(
        overflow: Overflow.visible,
        children: tiles
      ),
    );
    return content;
  }

//图层上的按钮（关闭）
Widget layerCloseBtnWidget(CustomerLayer item){
  return  Positioned(
      left: item.layerPosition.width,
      top: Utils.setHeight(layerHeaderHeight),
      child: Offstage(
        offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
        child: GestureDetector(
          child: Container(
            child:
                Image.asset('assets/images/edit/icon_close.png'),
            width: Utils.setWidth(layerOperationBtnWidth),
            height: Utils.setHeight(layerOperationBtnWidth),
          ),
          onTapDown: (TapDownDetails e) {
            deletLayer(item);
          }),
        ),
      );
}
//图层上的按钮（全屏）
Widget layerFullScreenBtnWidget(CustomerLayer item){
 return  Positioned(
      left: 0,
      top: Utils.setHeight(layerHeaderHeight),
      child: Offstage(
        offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
        child: GestureDetector(
          child: Container(
            child:
                Image.asset('assets/images/edit/icon_fullscreen.png'),
            width: Utils.setWidth(layerOperationBtnWidth),
            height: Utils.setHeight(layerOperationBtnWidth),
          ),
          onTapDown: (TapDownDetails e){
            fullScreen(item);
          }
        ),),
      );
}
//图层上的按钮（左边拖拽）
Widget layerDragLeftBtnWidget(CustomerLayer item){
  return  Positioned(
      left: 0,
      bottom: 0,
      child: Offstage(
        offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
        child: GestureDetector(
          child: Container(
            child:
                Image.asset('assets/images/edit/icon_leftzoom.png'),
            width: Utils.setWidth(layerOperationBtnWidth),
            height: Utils.setHeight(layerOperationBtnWidth),
          ),
          onPanStart: (DragStartDetails e){
            dragStart(e, item, 1);
          },
          onPanUpdate: (DragUpdateDetails e){
            dragUpdate(e, item, DragOrientation.left, 1);
          },
          onPanEnd: (DragEndDetails e){
            dragEnd(e, item, 1);
          },
        ),
      ),
  );
}
//图层上的按钮（右边拖拽）
Widget layerDragRightBtnWidget(CustomerLayer item){
  return  Positioned(
    left: item.layerPosition.width,
    bottom: 0,
    child: Offstage(
      offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
      child: GestureDetector(
        child: Container(
          child: Image.asset('assets/images/edit/icon_rightzoom.png'),
          width: Utils.setWidth(layerOperationBtnWidth),
          height: Utils.setHeight(layerOperationBtnWidth),
        ),
        onPanStart: (DragStartDetails e){
          dragStart(e, item, 2);
        },
        onPanUpdate: (DragUpdateDetails e){
          dragUpdate(e, item, DragOrientation.right, 2);
        },
        onPanEnd: (DragEndDetails e){
          dragEnd(e, item, 2);
        },
      ),
    ),
  );
}
dragStart(DragStartDetails e, CustomerLayer item, int dragType){
  if(isDraging) return;
  isDraging = true;
  _dragType = dragType;
  Provider.of<EditProvider>(context, listen: false).selectedLayerId = item.screenLayer.layerId;
  Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
  // LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);

  xDis = e.localPosition.dx - screenRenderBoxOffset.dx - item.layerPosition.left;
  yDis = e.localPosition.dy - screenRenderBoxOffset.dy - item.layerPosition.top;
  // layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, item.layerPosition.width, item.layerPosition.height);
  _preWidth = item.layerPosition.width;
  _preHeight = item.layerPosition.height;
  _startX = e.localPosition.dx;
  _startY = e.localPosition.dy;
  _startLeft = item.layerPosition.left;
  _startTop = item.layerPosition.top;
}
dragUpdate(DragUpdateDetails e, CustomerLayer item, DragOrientation orientation, int dragType) {
  if(isDraging && _dragType != dragType || !isDraging && _dragType != dragType) return;
  // print('位置---$_startX------${e.localPosition.dx}');
  Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
  LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
  num h = _preHeight;
  num w =  _preWidth;
  double currWidth = orientation == DragOrientation.left ?_preWidth + (_startX - e.localPosition.dx) : _preWidth + (e.localPosition.dx - _startX);
  double currHeight = _preHeight + (e.localPosition.dy - _startY);
  num top = item.layerPosition.top;//e.localPosition.dy
  num left = item.layerPosition.left; 
  
  if(currWidth >= layerMinWidth) {
    w =  orientation == DragOrientation.left ? _preWidth + (_startX - e.localPosition.dx) : _preWidth + (e.localPosition.dx - _startX);
    left = orientation == DragOrientation.left ? e.localPosition.dx - xDis - screenRenderBoxOffset.dx : left;
  } else {
    w = layerMinWidth;
    left = orientation == DragOrientation.left ? _startLeft + _preWidth - layerMinWidth : left; 
  }
  if(currHeight > layerMinHeight) {
    h =  _preHeight + (e.localPosition.dy - _startY);
  } else {
    h = layerMinHeight;
  }
  layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, w, h);
}
dragEnd(DragEndDetails e, CustomerLayer item, int dragType){
  if(isDraging && _dragType != dragType || !isDraging && _dragType != dragType) return;
  LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
  CustomerLayer layer = layerProvider.getLayer(item.screenLayer.layerId);
  layerZoom(layer);
  xDis = 0;
  yDis = 0;
  _startX = 0;
  _startY = 0;
  _startLeft = 0;
  _startTop = 0;
  isDraging = false;
  _dragType = -1;
}
//图层（不包括关闭、全屏按钮）
  Widget layerWidget(CustomerLayer item){
    var layerSource = item.hasSource && item?.screenLayer?.source?.name!=null;
    var noLayerSignal = !item.hasSignal;
    double borderWidth = Provider.of<EditProvider>(context, listen: false).flickerLayerId == item.screenLayer.layerId ? Utils.setWidth(2.0) 
                          : (!layerSource || noLayerSignal || Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId)? Utils.setWidth(1.0) : Utils.setWidth(0.0);
    
    int type = item.screenLayer?.source?.cropId==255 ? 0 : 1;
    int layerId = item.screenLayer?.layerId;
    return GestureDetector(
                child: Container(
                  // color: Colors.greenAccent,
                  width: item.layerPosition.width + Utils.setWidth(layerOperationBtnWidth/2), 
                        //Utils.setWidth(item.window.width * scale),
                  height: item.layerPosition.height + Utils.setHeight(layerOperationBtnWidth/2 + layerHeaderHeight) - borderWidth, //
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    //当前有其他用户正在操作提示
                    layerOperatingTip(item),
                    Container(
                      width: item.layerPosition.width, 
                        //Utils.setWidth(item.window.width * scale),
                      height: item.layerPosition.height,// - borderWidth, 
                        //Utils.setHeight(item.window.height * scale),
                      child: Stack(children: <Widget>[
                      //视频
                        Consumer<VideoState>(builder: (BuildContext context, data, Widget child) {
                          bool isVideoClosed = data.isVideoClosed == null? false : data.isVideoClosed;
                          return Container(
                            width: item.layerPosition.width,
                            height: item.layerPosition.height,
                            child: (!layerSource) ?  Container(color: item.noSourceColor) :
                              noLayerSignal? Container(color: item.noSignalColor)
                              : isVideoClosed ?  Image.asset('assets/images/input/input1.png', fit: BoxFit.fill)
                              : Container(
                                  color: ColorMap.layer_bg_nostream,
                                  child: Consumer<VideoProvider>(builder: (BuildContext context, data, Widget child) {
                                    return sdk.createView(item.screenLayer?.source?.inputId, item.screenLayer?.screenId, layerId, type, item.inputCrop?.x, item.inputCrop?.y, item.inputCrop?.width, item.inputCrop?.heigth, item.inputResolution?.width, item.inputResolution?.height, context);
                                  }),
                                  width: item.layerPosition.width,
                                  height: item.layerPosition.height,
                            ),
                            // Container(
                            //   width: item.layerPosition.width - borderWidth, 
                            //   height: item.layerPosition.height - borderWidth, 
                            //   child: (!layerSource) ?  Container(color: item.noSourceColor) :
                            //   noLayerSignal? Container(color: item.noSignalColor)
                            //   : Image.asset('assets/images/input/input1.png',
                            //     fit: BoxFit.fill),
                            );
                        }),
                        Column(children: <Widget>[
                          //图层标题
                          Container(
                            height: item.layerPosition.height - borderWidth - Utils.setHeight(4)< Utils.setHeight(32) ? item.layerPosition.height - borderWidth - Utils.setHeight(4) : Utils.setHeight(32),
                            child: layerHeader(item, layerSource, noLayerSignal, borderWidth)
                          ),
                          //图层是否有信号
                          Expanded(
                            child: Container(
                            // color: Colors.red,
                            width: item.layerPosition.width - borderWidth, 
                            // height: item.layerPosition.height - borderWidth - Utils.setHeight(32), 
                            alignment: Alignment.center,
                            child: 
                              Text('${!layerSource || noLayerSignal?  "无信号" : ""}',style: TextStyle(color: ColorMap.white),),//ColorMap.user_font_color
                            ),
                          ),
                        ],)
                      ],),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        border:
                            Border.all(
                              width: borderWidth, 
                              color:  Provider.of<EditProvider>(context, listen: false).flickerLayerId == item.screenLayer.layerId ? Colors.greenAccent[700]: (!layerSource || noLayerSignal)? ColorMap.white
                              : Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? ColorMap.border_layer_color : Colors.transparent //ColorMap.layer_border_color,
                            ),
                      ),
                    )
                  ],
                ),
              // ),
            ),
            onTapDown: (e){
              Provider.of<EditProvider>(context, listen: false).selectedLayerId = item.screenLayer.layerId;
            },
            onScaleStart: (ScaleStartDetails e) {
              // print('开始移动${e.focalPoint.dx}');
              Provider.of<EditProvider>(context, listen: false).selectedLayerId = item.screenLayer.layerId;
              Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
              // LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);

              xDis = e.focalPoint.dx - screenRenderBoxOffset.dx - item.layerPosition.left;
              yDis = e.focalPoint.dy - screenRenderBoxOffset.dy - item.layerPosition.top;
              // layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, item.layerPosition.width, item.layerPosition.height);
              _preWidth = item.layerPosition.width;
              _preHeight = item.layerPosition.height;
            },
            onScaleUpdate: (ScaleUpdateDetails e) {
              // print('移动更新${e.focalPoint.dx}');
              Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
              LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
              num h = _preHeight;
              num w =  _preWidth;
              final left = e.focalPoint.dx - xDis - screenRenderBoxOffset.dx;
              final top = e.focalPoint.dy - yDis - screenRenderBoxOffset.dy;
              // if(e.scale != 1){
              //   double hScale = e.horizontalScale.clamp(0.5, 4);
              //   double vScale = e.verticalScale.clamp(0.5, 4);
              //   w =  _preWidth * hScale;
              //   h = _preHeight * vScale;
              //   if(w < 100){
              //     w = 100;
              //   }
              //   if(h < 80){
              //     h = 80;
              //   }
              //   preHscale = hScale;
              //   preVscale = vScale;
              // }
              layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, w, h);
            },
            onScaleEnd: (ScaleEndDetails e) {
              LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
              CustomerLayer layer = layerProvider.getLayer(item.screenLayer.layerId);
              layerZoom(layer);
              xDis = 0;
              yDis = 0;
              // print('移动结束');
            },
          );
  }
  //图层标题、全屏按钮、删除按钮
  Widget layerHeader(CustomerLayer item, bool layerSource, bool noLayerSignal, double borderWidth){
    return Offstage(
      offstage: !layerSource || noLayerSignal || Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
      child:  Container(
        width: item.layerPosition.width - borderWidth, 
        color: ColorMap.mask_layer_color,
        alignment: Alignment.centerLeft,
        child:
          Row(children: <Widget>[
            new Expanded(
              flex: 1,
              child:  Container(
                // width: item.layerPosition.width, 
                // height: Utils.setHeight(32),
                // color: ColorMap.mask_layer_color,
                alignment: Alignment.center,
                // padding: EdgeInsets.only(left: Utils.setWidth(11)),
                child: Text('${layerSource? (item?.screenLayer?.source?.name) : "无源图层"}',
                  style: TextStyle(color: ColorMap.white),
                  overflow: TextOverflow.ellipsis),
            ),),
          ],),)
      );
  }
  //其他用户正在操作图层提示
  Widget layerOperatingTip(CustomerLayer item){
    LayerTipProvider layerTipProvider = Provider.of<LayerTipProvider>(context);
    var layerTip =layerTipProvider.layerTips.firstWhere((p)=>p.screenId==item.screenLayer.screenId && p.layerId == item.screenLayer.layerId,orElse: ()=>null);
    var isOffstage = layerTip != null && layerTip.tipState? false : true;
    String txt = '';
    if(layerTip != null && layerTip.tipState){
      txt = layerTip.user + '正在修改' + item.screenLayer?.general?.name;
    }
    return Container(
      // color: Colors.yellowAccent,
      constraints: BoxConstraints(maxWidth: Utils.setWidth(layerTipMaxWidth),maxHeight: Utils.setHeight(layerHeaderHeight)),
      height: Utils.setHeight(layerHeaderHeight),
      child: Offstage(
        offstage: isOffstage,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // width: Utils.setWidth(142),
              padding: EdgeInsets.symmetric(horizontal: Utils.setWidth(10)),
              height: Utils.setWidth(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: ColorMap.layer_operating_bkg_color,
              ),
              child: Text(
                "$txt",
                style: TextStyle(
                  color: ColorMap.white,//ColorMap.button_font_color,
                  fontSize: Utils.setFontSize(14)),
              ),
            ),
            Container(
              width: Utils.setWidth(16),
              // height: Utils.setHeight(12),
              margin: EdgeInsets.symmetric(horizontal: Utils.setWidth(8)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: Utils.setWidth(8),
                    color: ColorMap.layer_operating_bkg_color,//三角形边框颜色
                  ),
                  left: BorderSide(
                    width: Utils.setWidth(8),
                    color: Colors.transparent, //三角形边框颜色
                  ),
                  right: BorderSide(
                    width: Utils.setWidth(8),
                    color: Colors.transparent, //三角形边框颜色
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //图层缩放平移async 
   layerZoom(CustomerLayer customerLayer) {
    if(customerLayer == null) return;
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    double radioW = Provider.of<RenderBoxProvider>(context, listen: false)
        .getRatioW(editProvider.currentScreen?.outputMode?.size?.width);
    double radioH = Provider.of<RenderBoxProvider>(context, listen: false)
        .getRatioH(editProvider.currentScreen?.outputMode?.size?.height);
    int x = ((customerLayer.layerPosition.left) / radioW +
        editProvider.currentScreen?.outputMode?.size?.x).round();
    int y = ((customerLayer.layerPosition.top) / radioH +
        editProvider.currentScreen?.outputMode?.size?.y).round();
    int w = ((customerLayer.layerPosition.width) / radioW).round();
    int h = ((customerLayer.layerPosition.height) / radioH).round();
    // print('变化后大小-${customerLayer.layerPosition.width}---${customerLayer.layerPosition.height}-- ${w}---${h}---${customerLayer.screenLayer?.window?.width}---${customerLayer.screenLayer?.window?.height}');
    Map layerParams = {
      'deviceId': 0,
      'screenId': customerLayer.screenLayer?.screenId,
      'layerId': customerLayer.screenLayer?.layerId,
      'width': w, //customerLayer.screenLayer?.window?.width,
      'height': h, //customerLayer.screenLayer?.window?.height,
      'x': x,
      'y': y,
    };
    writeLayerWindow(layerParams, isNeedAwait: false);
  }
//调用接口（改变图层大小位置）
writeLayerWindow(Map layerParams, {bool isNeedAwait = true}) async{
  try {
      HttpUtil http = HttpUtil(context).getInstance();
      // print(layerParams);
      if(isNeedAwait) {
        final res = await http.request(Api.WRITE_LAYER_WINDOW, data: layerParams);
        if (res.code != 0) return;
        updateLocal(layerParams);
      }else {
        http.request(Api.WRITE_LAYER_WINDOW, data: layerParams);
        updateLocal(layerParams);
      }
    } catch (e) {
      print(e);
    }
}
//调用接口后，更新本地数据
updateLocal(Map layerParams){
  int index = Provider.of<EditProvider>(context, listen: false)
          .currentScreen
          .screenLayers
          .indexWhere((p) => p.layerId == layerParams['layerId']);
      Provider.of<EditProvider>(context, listen: false)
              .currentScreen
              .screenLayers[index]
              .window =
          new Window(
              width: layerParams['width'],
              height: layerParams['height'],
              x: layerParams['x'],
              y: layerParams['y'],
              screenId: layerParams['screenId'],
              layerId: layerParams['layerId']);
      Provider.of<EditProvider>(context, listen: false).forceUpdate();
}
//输入拼接stack
  Widget outputModeListWidget(List<ScreenInterface> screenInterfaces) {
    if (screenInterfaces == null) return null;
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in screenInterfaces) {
      if(item.x == 0 || item.y == 0) continue;
      tiles.add(Positioned(
        left:
            Utils.setWidth((item.x - screenRealX) / screenRealW * screenWidth),
        top: Utils.setHeight(
            (item.y - screenRealY) / screenRealH * screenHeight),
        child: Container(
          width: Utils.setWidth(item.width / screenRealW * screenWidth),
          height: Utils.setHeight(item.height / screenRealH * screenHeight),
          decoration: BoxDecoration(
            color: bkgEnable == 1 ? Colors.transparent : ColorMap.screen_color,
            border: Border.all(
                  width: Utils.setWidth(1.0),
                  color: ColorMap.screen_border_color,
                ),
            // Border(
                // bottom: BorderSide(
                //   width: Utils.setWidth(1.0),
                //   color: ColorMap.screen_border_color,
                // ),
                // right: BorderSide(
                //   width: Utils.setWidth(1.0),
                //   color: ColorMap.screen_border_color,
                // ),
                
            // )
        ),
      )));
    }
    content = new Stack(children: tiles);
    return content;
  }

//背景Stack
  Widget bkgWidget(bool isEnable) {
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    String bkgUrl = '';
    if (isEnable) {
      bkgUrl = editProvider.currentScreen?.bkg?.imgUrl;
    }
    // print('背景---$isEnable---${Global.getBaseUrl}$bkgUrl');
    return isEnable == true
        ? Stack(children: <Widget>[
            Positioned(
                left: Utils.setWidth(0),
                top: Utils.setHeight(0),
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: Utils.setWidth(screenWidth),
                    height: Utils.setHeight(screenHeight),
                    child: Global.getBaseUrl!=null && bkgUrl!=null? Image.network('${Global.getBaseUrl}$bkgUrl',
                        fit: BoxFit.fill) : null,
                  ),
                ))
          ])
        : null;
  }

  //打印渲染后的组件尺寸
  _printSize() {
    if (!mounted) return;
    // Size size = context?.findRenderObject()?.paintBounds?.size;
    // Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxSize =
    //     size;
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      RenderBox screenRegionBox = _screenRegionKey.currentContext.findRenderObject();
      Offset screenRegionOffset = screenRegionBox.localToGlobal(Offset.zero);
      // print('屏幕offset111111---${screenRegionOffset}');
      RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
      renderBoxProvider.screenRenderBoxOffset = screenRegionOffset;
    });
  }

  //生成页面绑定的CustomerLayer
  generatCustomerLayer(){
    EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
    List<ScreenLayer> layerListData =
          editProvider.currentScreen?.screenLayers;//widget.
      layerListData = ListOperation.sortLayerByZorder(layerListData);
      List<CustomerLayer> customerLayers = generateLayersData(layerListData,
          editProvider.currentScreen?.outputMode?.size, scale);//widget.
      Provider.of<LayerProvider>(context, listen: false).customerLayers =
          customerLayers;
  }
  //生成CustomerLayer
  List<CustomerLayer> generateLayersData(
      List<ScreenLayer> layerListData, OutputSize outputSize, double scale) {
    List<CustomerLayer> customerLayers;
    if (layerListData == null) return customerLayers;
    bool hasSource = false;
    bool hasSignal = false;
    Color noSignalColor = ColorMap.layer_noSignal_color; //ColorGenerator.randomGenerator();//Color.fromARGB(255, Random().nextInt(256)+0, Random().nextInt(256)+0, Random().nextInt(256)+0);
    Color noSourceColor = ColorMap.layer_noSource_color;
    customerLayers = List();
    List<VideoModel> videoLayers = List();
    InputCrop inputCrop;
    InputResolution inputResolution;
    for (var item in layerListData) {
      // print('item的id---${item.source?.cropId}');
      var left = outputSize == null
          ? 0
          : Utils.setWidth((item.window.x - outputSize.x) * scale);
      var top = outputSize == null
          ? 0
          : Utils.setHeight((item.window.y - outputSize.y) * scale);
      var w = item.window.width==null? Utils.setWidth(100):Utils.setWidth(item.window.width * scale);
      var h = item.window.height==null? Utils.setHeight(100):Utils.setHeight(item.window.height * scale);
      InputProvider inputProvider = Provider.of<InputProvider>(context, listen: false);
      if(item.source != null) {
        //中间件返回的sourceType为1，去查询输入列表，如果能查到为有源，如果查不到为无源
        if(item.source.sourceType == 1) { 
          int inputIndex = inputProvider.findInputSourceById(item.source.inputId, item.source.cropId);
          if(inputIndex != -1) {
            //找到输入源
            hasSignal = inputProvider.onlineInputList[inputIndex].iSignal == 1;
            inputResolution = inputProvider.onlineInputList[inputIndex].resolution;
            if(item.source.cropId != 255) {
              int cropIndex = inputProvider.findCropSourceById(inputProvider.onlineInputList[inputIndex], item.source.cropId);
              if(cropIndex != -1) {
                hasSource = true;
                inputCrop = inputProvider.onlineInputList[inputIndex].crops[cropIndex];
              } else {
                hasSource = false;
              }
            } else {
              hasSource = true;
            }
          } else { //没有找到输入源
            hasSource = false;
            hasSignal = false;
          }
        

        // if(inputIndex != -1) {
        //   hasSignal = inputProvider.onlineInputList[inputIndex].iSignal == 1;
        //   if(item.source.cropId != 255) {
        //     int cropIndex = inputProvider.findCropSourceById(inputProvider.onlineInputList[inputIndex], item.source.cropId);
        //     if(cropIndex != -1) {
        //       item.source.sourceType = 1;
        //     } else {
        //       item.source.sourceType = 0;
        //     }
        //   }
          // if(inputProvider.inputList[inputIndex].general?.name == 'input 1-1'){
          //   print('屏幕上input 1-1的索引---------$inputIndex');
          // }
          //item.source.sourceType = 1; // s4: 查询输入源列表能查到并且online==1，才是有源图层
        // } else {
        //   hasSignal = false;
        //   item.source.sourceType = 0; 
        // }
        } else { //中间件返回的sourceType==0，无源无信号
          hasSource = false;
          hasSignal = false;
        }
      }
      customerLayers.add(new CustomerLayer(
          screenLayer: item,
          layerPosition:
              new LayerPosition(left: left, top: top, width: w, height: h),
          hasSource: hasSource,
          hasSignal: hasSignal,
          noSignalColor: noSignalColor,
          noSourceColor: noSourceColor,
          inputCrop: inputCrop,
          inputResolution: inputResolution
        ));
      videoLayers.add(new VideoModel(screenId: item.screenId, layerId: item.layerId, inputId: item.source?.inputId));
    }
//    Provider.of<VideoProvider>(context, listen: false).videoList = videoLayers;
    return customerLayers;
  }

  //删除图层
  deletLayer(CustomerLayer customerLayer) async {
    Map params = {
      'deviceId': 0,
      'screenId': customerLayer.screenLayer?.screenId,
      'layerId': customerLayer.screenLayer?.layerId,
    };
    try {
      HttpUtil http = HttpUtil(context).getInstance();
      final res = await http.request(Api.DELETE_LAYER, data: params);
      if (res.code != 0) return;
      int index = Provider.of<EditProvider>(context, listen: false)
          .currentScreen
          .screenLayers
          .indexWhere((p) => p.layerId == customerLayer.screenLayer.layerId);
      if(index!=-1){
        Provider.of<EditProvider>(context, listen: false).currentScreen.screenLayers.removeAt(index);
        Provider.of<EditProvider>(context, listen: false).forceUpdate();
      }
    } catch (e) {
      print(e);
    }
  }

  //全屏
  fullScreen(CustomerLayer customerLayer) async{
    if(customerLayer == null) return;
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    int x = editProvider.currentScreen?.outputMode?.size?.x;
    int y = editProvider.currentScreen?.outputMode?.size?.y;
    int w = (screenWidth / scale).round();
    int h = (screenHeight / scale).round();
    // print('变化后大小-${customerLayer.layerPosition.width}---${customerLayer.layerPosition.height}-- ${w}---${h}---${customerLayer.screenLayer?.window?.width}---${customerLayer.screenLayer?.window?.height}');
    Map layerParams = {
      'deviceId': 0,
      'screenId': customerLayer.screenLayer?.screenId,
      'layerId': customerLayer.screenLayer?.layerId,
      'width': w, //customerLayer.screenLayer?.window?.width,
      'height': h, //customerLayer.screenLayer?.window?.height,
      'x': x,
      'y': y,
    };
    writeLayerWindow(layerParams);
  }
  
  dragLayerLeft(CustomerLayer customerLayer){

  }
 
  void _onAfterRendering(Duration timeStamp){
    //这里编写获取元素大小和位置的方法
    try {
      RenderBox screenRegionRenderBox =
      _screenRegionKey.currentContext?.findRenderObject();
      if(screenRegionRenderBox == null) return;
      RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
      Size size = renderBoxProvider.screenRenderBoxSize;
      if(size == null || size.width != screenRegionRenderBox.paintBounds.size.width || size.height != screenRegionRenderBox.paintBounds.size.height){
        renderBoxProvider.screenRenderBoxSize = screenRegionRenderBox.paintBounds.size; 
        renderBoxProvider.screenRenderBoxOffset = screenRegionRenderBox.localToGlobal(Offset(0, 0));
          // print('更新：${screenRegionRenderBox.paintBounds.size}');
          // print('屏幕：${renderBoxProvider.screenRenderBoxOffset}');
          // print('编辑：${renderBoxProvider.editRenderBoxOffset}');
      }
    } catch(e) {
      print('获取屏幕尺寸错误$e');
      EasyLoading.dismiss();
    }
  }
}
