// 屏幕部分
import 'package:flutter/material.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/CustomerSizeChangedLayoutNotifier.dart';
import 'package:h_pad/common/layer_helper.dart';
import 'package:h_pad/common/opacity_animation.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/screen/LayerPosition.dart';
import 'package:h_pad/models/screen/OutPutModel.dart';
import 'package:h_pad/models/screen/ScreenLayersModel.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/LayerProvider.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:flutter/rendering.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/common/global.dart';

class ScreenView extends StatefulWidget {
  final EditProvider editProvider;
  ScreenView(this.editProvider);
  @override
  _ScreenViewState createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView>  with TickerProviderStateMixin{
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
  double _preWidth; //缩放之前图层的宽度
  double _preHeight; //缩放之前图层的高度
  double _preLeft;
  double _preTop;
  GlobalKey _screenRegionKey = GlobalKey();
  // AnimationController controller; //动画控制器
  // CurvedAnimation curved; //曲线动画，动画插值，
  // bool forward = true;
  @override
  void initState() {
    setScreenSize();
    // controller = new AnimationController(
    //     vsync: this, 
    //     duration: const Duration(seconds: 3),
    //     animationBehavior: AnimationBehavior.preserve);
    // curved = new CurvedAnimation(parent: controller, curve: Curves.bounceOut);//模仿小球自由落体运动轨迹
    // // animation = new Tween(begin: 100.0, end: 200.0).animate(controller);
    // controller.repeat(reverse: true);
    // print('屏幕初始化----------');
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didChangeDependencies();
  }
 
  @override
  void didUpdateWidget(oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didUpdateWidget(oldWidget);
  }
 
  void _onAfterRendering(Duration timeStamp){
    //这里编写获取元素大小和位置的方法
    
    RenderBox screenRegionRenderBox =
      _screenRegionKey.currentContext.findRenderObject();
    RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
    Size size = renderBoxProvider.screenRenderBoxSize;
    if(size == null || size.width != screenRegionRenderBox.paintBounds.size.width || size.height != screenRegionRenderBox.paintBounds.size.height){
      renderBoxProvider.screenRenderBoxSize = screenRegionRenderBox.paintBounds.size; 
      renderBoxProvider.screenRenderBoxOffset = screenRegionRenderBox.localToGlobal(Offset(0, 0));
        // print('更新：${screenRegionRenderBox.paintBounds.size}');
        // print('屏幕：${renderBoxProvider.screenRenderBoxOffset}');
        // print('编辑：${renderBoxProvider.editRenderBoxOffset}');
    }
  }

  @override
  Widget build(BuildContext context) {
    setScreenSize();
    setState(() {
      screenWidth = screenWidth;
      screenHeight = screenHeight;
      bkgEnable = bkgEnable;
    });
    Future.delayed(Duration(milliseconds: 0)).then((e) {
      generatCustomerLayer();
    });
    // print('重绘屏幕');
    return NotificationListener<LayoutChangedNotification>(
      onNotification: (notification) {
        /// 收到布局结束通知,打印尺寸
        /// flutter1.7之后需要返回值,之前是不需要的.
        // _printSize();
        return null;
      },
      child: CustomerSizeChangedLayoutNotifier(
        child: GestureDetector(
          child: Container(
            width: Utils.setWidth(LayoutConstant.EditWidth),
            height: Utils.setHeight(LayoutConstant.EditHeight),
            alignment: Alignment.center,
            // color: Colors.yellow,
            child: Stack(
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
                    color: ColorMap.screen_color,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: bkgWidget(bkgEnable == 1),
                        ),
                        Container(
                          child: outputModeListWidget(widget.editProvider
                              .currentScreen?.outputMode?.screenInterfaces),
                        ),
                      ],
                    ),
                  ),
              ),
              
              // 图层容器的宽高为编辑区宽高，为了解决layer超出stack区域时，拖动layer感应不到手势的问题
              Container(
                width: Utils.setWidth(LayoutConstant.EditWidth),
                height: Utils.setHeight(LayoutConstant.EditHeight),
                color: Colors.transparent,//ColorMap.screen_color,
                child: 
                Consumer2<LayerProvider, RenderBoxProvider>(
                        builder: (BuildContext context, data1, data2, Widget child) {
                      return Container(
                        child: layerListWidget(),
                      );
                    }),
                ),
            ],)
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
    // print('计算时候---${Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset?.dy}');
    if (customerLayers == null || screenRenderBoxOffset == null) return null;
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in customerLayers) {
      // print('图层位置---${item.layerPosition.top}----${Provider.of<RenderBoxProvider>(context, listen: false).screenFromEditTop}');
      tiles.add(
        Positioned(
          key: Key(item.screenLayer.layerId.toString()),
          left: item.layerPosition.left + Provider.of<RenderBoxProvider>(context, listen: false).screenFromEditLeft, 
          top: item.layerPosition.top + Provider.of<RenderBoxProvider>(context, listen: false).screenFromEditTop, 
              //Utils.setHeight((item.screenLayer.window.y - screenRealY) * scale),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
            layerWidget(item),
            // layerBtnWidget(item), //删除、全屏按钮暂时隐藏，使用临时的
          ],)
          
        ),
      );
    }
    content = new Stack(overflow: Overflow.visible, children: tiles);
    return content;
  }

//图层上的按钮（关闭、全屏、拖放按钮）
Widget layerBtnWidget(CustomerLayer item){
  return  Positioned(
      right: Utils.setWidth(-16),
      top: Utils.setHeight(-16),
      child: Offstage(
        offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
        child: GestureDetector(
                child: Container(
                  child:
                      Image.asset('assets/images/edit/icon_close.png'),
                  width: Utils.setWidth(32),
                  height: Utils.setHeight(32),
                ),
                onTap: () {
                  
                }),
        ),
      );
}

//图层（不包括关闭、全屏按钮）
  Widget layerWidget(CustomerLayer item){
    var layerSource = item.screenLayer.source.sourceType == 1 && item?.screenLayer?.source?.name!=null? item?.screenLayer?.source?.name : "无源图层";
    var layerSignal = item.screenLayer.source.sourceType == 1 && !item.hasSignal ? "无信号" : "";
    // print('item.hasSource------${item.hasSource}----${item?.screenLayer?.source?.name}');
    return GestureDetector(
            child: Container(
              width: item.layerPosition.width, 
                  //Utils.setWidth(item.window.width * scale),
              height: item.layerPosition.height, 
                  //Utils.setHeight(item.window.height * scale),
              child: 
              Stack(children: <Widget>[
                //视频
                Container(
                  width: item.layerPosition.width, 
                  height: item.layerPosition.height, 
                  child: 
                  Image.asset('assets/images/input/input1.png',
                    fit: BoxFit.fill),
                ),
                //图层标题
                Positioned(
                  child: Offstage(
                    offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
                    child:  Container(
                      width: item.layerPosition.width, 
                      height: Utils.setHeight(32),
                      color: ColorMap.mask_layer_color,
                      alignment: Alignment.center,
                      child: Text('$layerSource',
                        style: TextStyle(color: ColorMap.user_font_color),
                        overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                //图层是否有信号
                Container(
                  width: item.layerPosition.width, 
                  height: item.layerPosition.height, 
                  alignment: Alignment.center,
                  child: 
                    Text('$layerSignal',style: TextStyle(color: ColorMap.orange_selected),),//ColorMap.user_font_color
                ),
                //图层关闭、全屏按钮（暂时的）
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    // color: Colors.red,
                    // width: Utils.setWidth(84), 
                    height: Utils.setHeight(32),
                    alignment: Alignment.centerRight,
                    child: 
                    Offstage(
                          offstage: Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? false : true,
                          child: Row(children: <Widget>[
                            //全屏按钮
                            GestureDetector(
                              child: Container(
                              width: Utils.setWidth(16), 
                              height: Utils.setHeight(16),
                              margin: EdgeInsets.only(right: Utils.setHeight(10)),
                              child: Image.asset('assets/images/edit/button_fullscreen_normal.png',
                                      fit: BoxFit.fill),
                              ),
                              onTapDown: (TapDownDetails e){
                                fullScreen(item);
                              },
                            ),
                            //删除按钮
                            GestureDetector(
                              child: Container(
                              width: Utils.setWidth(16), 
                              height: Utils.setHeight(16),
                              margin: EdgeInsets.only(right: Utils.setHeight(8)),
                              child: Image.asset('assets/images/edit/button_close_normal.png',
                                      fit: BoxFit.fill),
                              ),
                              onTapDown: (TapDownDetails e){
                                deletLayer(item);
                              },
                            ),
                          ],)
                      ),
                    ),
                  ),  
                // Positioned(
                //   child: new FadeTransition(//透明度动画
                //   opacity: curved,//将动画传入不同的动画widget
                //   child: 
                //     Container(
                //       width: item.layerPosition.width, 
                //       height: item.layerPosition.height, 
                //       color: ColorMap.user_font_color,
                //       ),
                //   ),
                // ),
              ],),
              decoration: BoxDecoration(
                border:
                    Border.all(
                      width: Provider.of<EditProvider>(context, listen: false).flickerLayerId == item.screenLayer.layerId ? Utils.setWidth(2.0) 
                      : Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? Utils.setWidth(1.0) : 0, 
                      color: Provider.of<EditProvider>(context, listen: false).flickerLayerId == item.screenLayer.layerId ? Colors.greenAccent[700]
                      : Provider.of<EditProvider>(context, listen: false).selectedLayerId == item.screenLayer.layerId? ColorMap.border_layer_color : Colors.transparent //ColorMap.layer_border_color,
                    ),
              ),
            ),
            onTap: (){
              Provider.of<EditProvider>(context, listen: false).selectedLayerId = item.screenLayer.layerId;
            },
            onScaleStart: (ScaleStartDetails e) {
              print('开始移动${e.focalPoint.dx}');
              Provider.of<EditProvider>(context, listen: false).selectedLayerId = item.screenLayer.layerId;
              Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
              LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);

              xDis = e.focalPoint.dx - screenRenderBoxOffset.dx - item.layerPosition.left;
              yDis = e.focalPoint.dy - screenRenderBoxOffset.dy - item.layerPosition.top;
              _preLeft = e.focalPoint.dx - xDis - screenRenderBoxOffset.dx;
              _preTop = e.focalPoint.dy - yDis - screenRenderBoxOffset.dy;
              // layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, item.layerPosition.width, item.layerPosition.height);
              _preWidth = item.layerPosition.width;
              _preHeight = item.layerPosition.height;
            },
            onScaleUpdate: (ScaleUpdateDetails e) {
              // print('移动更新${e.focalPoint.dx}');
              Offset screenRenderBoxOffset = Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxOffset;
              LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
              num left = _preLeft;
              num top = _preTop;
              num h = _preHeight;
              num w =  _preWidth;
              if(e.scale == 1) {
                left = e.focalPoint.dx - xDis - screenRenderBoxOffset.dx;
                top = e.focalPoint.dy - yDis - screenRenderBoxOffset.dy;
              } else {
                h = _preHeight * e.verticalScale.clamp(0.8, 2);
                w =  _preWidth * e.horizontalScale.clamp(0.8, 2);
                print('移动更新-----垂直比例${e.verticalScale}------水平比例${e.horizontalScale}-----差${w-_preWidth}');
              }
              // final left = e.focalPoint.dx - xDis - screenRenderBoxOffset.dx;
              // final top = e.focalPoint.dy - yDis - screenRenderBoxOffset.dy;
              // final h = _preHeight * e.verticalScale.clamp(0.8, 2);
              // final w =  _preWidth * e.horizontalScale.clamp(0.8, 2);
              // print('缩放 --- ${e.verticalScale.clamp(0.8, 10)}---${e.horizontalScale.clamp(0.8, 10)}');
              // print('大小--- ${item.layerPosition.width}---${item.layerPosition.height}');
              layerProvider.updateCustomerLayerPosition(item.screenLayer.layerId, left, top, w, h);
            },
            onScaleEnd: (ScaleEndDetails e) {
              LayerProvider layerProvider = Provider.of<LayerProvider>(context, listen: false);
              CustomerLayer layer = layerProvider.getLayer(item.screenLayer.layerId);
              layerZoom(layer);
              xDis = 0;
              yDis = 0;
            },
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
      tiles.add(Positioned(
        left:
            Utils.setWidth((item.x - screenRealX) / screenRealW * screenWidth),
        top: Utils.setHeight(
            (item.y - screenRealY) / screenRealH * screenHeight),
        child: Container(
          width: Utils.setWidth(item.width / screenRealW * screenWidth),
          height: Utils.setHeight(item.height / screenRealH * screenHeight),
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: ColorMap.screen_border_color)),
        ),
      ));
    }
    content = new Stack(children: tiles);
    return content;
  }

//背景Stack
  Widget bkgWidget(bool isEnable) {
    String bkgUrl = '';
    if (isEnable) {
      bkgUrl = widget.editProvider.currentScreen?.bkg?.imgUrl;
    }
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
                    child: Image.network('${Global.getBaseUrl}$bkgUrl',
                        fit: BoxFit.fill),
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

// 设置屏幕尺寸
  setScreenSize() {
    if (widget.editProvider.currentScreen != null &&
        widget.editProvider.currentScreen.outputMode != null &&
        widget.editProvider.currentScreen.outputMode.size != null) {
      screenRealW = widget.editProvider.currentScreen.outputMode.size.width;
      screenRealH = widget.editProvider.currentScreen.outputMode.size.height;
      screenRealX = widget.editProvider.currentScreen.outputMode.size.x;
      screenRealY = widget.editProvider.currentScreen.outputMode.size.y;
      bkgEnable = widget.editProvider.currentScreen.bkg.enable;
    }
    // print('真实的宽度：${screenRealW}');
    // print('真实的高度：${screenRealH}');
    if (screenRealW != 0 && screenRealH != 0) {
      if (screenRealW > screenRealH) {
        screenWidth = (LayoutConstant.UILayoutWidth -
                LayoutConstant.PresetListWidth -
                LayoutConstant.SplitScrernWidth -
                30 * 2)
            .toDouble();
        screenHeight = screenRealH / screenRealW * screenWidth;
        if (screenHeight > screenHeightBlank) {
          // 处理高超出空白区域的情况
          screenHeight = screenHeightBlank;
          screenWidth = screenRealW / screenRealH * screenHeight;
        }
      } else {
        screenHeight = (LayoutConstant.UILayoutHeight -
                LayoutConstant.HeadHeight -
                LayoutConstant.InputListHeight -
                LayoutConstant.ActionBtnHeight -
                30 * 2)
            .toDouble();
        screenWidth = screenRealW / screenRealH * screenHeight;
        if (screenWidth > screenWidthBlank) {
          screenWidth = screenWidthBlank;
          screenHeight = screenRealH / screenRealW * screenWidth;
        }
      }
      scale = screenWidth / screenRealW;
      // print('计算后的屏幕比例： $scale');
      // print('计算后的屏幕比例： $screenWidth----$screenRealW');
    }

    //  print('计算后的屏幕宽高： ${Utils.setWidth(screenWidth)} ${Utils.setHeight(screenHeight)}');
  }

  //生成页面绑定的CustomerLayer
  generatCustomerLayer(){
    List<ScreenLayer> layerListData =
          widget.editProvider.currentScreen?.screenLayers;
      layerListData = ListOperation.sortLayerByZorder(layerListData);
      List<CustomerLayer> customerLayers = generateLayersData(layerListData,
          widget.editProvider.currentScreen?.outputMode?.size, scale);
      Provider.of<LayerProvider>(context, listen: false).customerLayers =
          customerLayers;
  }
  //生成CustomerLayer
  List<CustomerLayer> generateLayersData(
      List<ScreenLayer> layerListData, OutputSize outputSize, double scale) {
    List<CustomerLayer> layerPositons;
    if (layerListData == null) return layerPositons;
    bool hasSource = false;
    bool hasSignal = false;
    layerPositons = List();
    for (var item in layerListData) {
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
        int inputIndex = inputProvider.findInputSourceById(item.source.inputId, item.source.cropId);
        if(inputIndex != -1) {
          hasSignal = inputProvider.inputList[inputIndex].iSignal == 1;
        } else {
          hasSignal = false;
          item.source.sourceType = 0; 
        }
      }
      layerPositons.add(new CustomerLayer(
          screenLayer: item,
          layerPosition:
              new LayerPosition(left: left, top: top, width: w, height: h),
          hasSource: hasSource,
          hasSignal: hasSignal));
    }
    return layerPositons;
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

}
