// 编辑操作区域
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/common/PopupRoute.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/screen/ScreenModel.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:h_pad/views/Edit/toolbarWidget/BrightnessSlider.dart';
import 'package:h_pad/widgets/PopupWidget.dart';
import 'ScreenView.dart';
import 'SplitScreenTemplateView.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/api/http.dart';
import 'package:h_pad/api/api.dart';
import 'package:h_pad/video/videoplayer.dart';
import 'package:h_pad/video/videoparam.dart';


class EditMainView extends StatefulWidget {
  @override
  _EditMainViewState createState() => _EditMainViewState();
}

class _EditMainViewState extends State<EditMainView> {
  static const int toolbarFromBottom = 19;
  static const int brightnessContainerFromBottom = 56;
  static const int brightnessContainerFromRight = 185;
  static const int toolIconWidth = 26;
  static const int toolIconHeight = 26;
  static const int toolIconMargin = 28;
  static const int brightnessContainerWidth = 358;
  static const int brightnessContainerHeight = 67;
  static const int brightnessContainerSliderHeight = 55;
  static const int triangleWidth = 11;
  static const int triangleHeight = 12;

  static const double ftbTime = 1.5; //黑屏时间

  int isFreeze = 0;
  int screenId = -1;
  int isLock = 0;
  bool isBlackScreen = false;

  GlobalKey _brightnessIconKey = GlobalKey();
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
  Offset _brightnessIconOffset;

  @override
  void initState() {
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

  void _onAfterRendering(Duration timeStamp){
    //这里编写获取元素大小和位置的方法
    try {
      RenderBox brightnessIconRenderBox =
      _brightnessIconKey.currentContext?.findRenderObject();
      if(brightnessIconRenderBox == null) return;
      _brightnessIconOffset = brightnessIconRenderBox.localToGlobal(Offset(0, 0));
    } catch(e) {
      print('获取尺寸错误$e');
      EasyLoading.dismiss();
    }
  }
  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    isFreeze = editProvider.currentScreen?.freeze?.enable;
    screenId = editProvider.currentScreenId;
    isLock = editProvider.currentScreen?.isLock;
    isBlackScreen = editProvider.currentScreen?.ftb?.enable == 0 ? true : false;
    return Container(
      color: ColorMap.screen_bkg_color,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            right: Utils.setWidth(72 + 16),
            top: Utils.setHeight(6),
            child: Container(
              alignment: Alignment.centerRight,
              height: Utils.setHeight(24),
              child: Consumer<AuthProvider>(
                builder: (BuildContext context, data, Widget child) {
                  if(!data.hasAuthed && data.remainingTime <= 0){
                    Future.delayed(Duration(milliseconds:1000)).then((e) {
                      // Navigator?.of(context)..pop()..pop();
                      data.tipCode = 1;
                      if(this.context!=null){
                        Navigator.of(this.context).pushNamedAndRemoveUntil('Init', (Route route) =>false);
                      }
                    });
                  }
                  num hour = data.remainingTime / 60;
                  num day = hour / 24;
                  String strTime = day > 1 ? day.floor().toString() + '天': hour > 1 ? hour.floor().toString() + '小时' : (data.remainingTime % 60).toString() + '分钟';
                  String txt = data.hasAuthed ? '': data.remainingTime <= 0 ? '授权已到期' : '授权将在$strTime后到期';
                  return Text(txt, 
                    style: TextStyle(color: ColorMap.version_font, fontSize: Utils.setWidth(14)),textAlign: TextAlign.end,);
                })
            ),
          ),
          //屏幕
          Positioned(
              left: 0,
              width: Utils.setWidth(LayoutConstant.EditWidth),
              child: Offstage(
                offstage: screenId == -1,
                child: Container(
                  // color: Colors.red,
                  alignment: Alignment.center,
                  height:
                      Utils.setHeight(LayoutConstant.EditHeight), //EditProvider,
                  child: Consumer<InputProvider>(
                      builder: (BuildContext context, data, Widget child) {
                    return ScreenView(); //
                  }),
                ),
              )),
          //工具栏
          Positioned(
              // width: Utils.setWidth(LayoutConstant.EditWidth),
              // height: Utils.setWidth(26),
              bottom: Utils.setHeight(toolbarFromBottom), //toolbarFromBottom
              // left: Utils.setWidth(255),
              child: Offstage(
                  offstage: screenId == -1,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(Utils.setWidth(8)),
                    child: Container(
                      // height: Utils.setHeight(26),
                      // color: Colors.green,
                      child: _toolbar(context),
                    ),
                  ))),
          //模板开窗
          Container(
            decoration: new BoxDecoration(
              border: Border(
                left: BorderSide(
                    width: Utils.setWidth(1),
                    color: ColorMap.splitScreen_border_color),
              ),
            ),
            margin:
                EdgeInsets.only(left: Utils.setWidth(LayoutConstant.EditWidth)),
            width: Utils.setWidth(LayoutConstant.SplitScrernWidth),
            child: Consumer<RenderBoxProvider>(
                builder: (BuildContext context, data, Widget child) {
              return SplitScreenTemplateView(data);
            }),
          ),
          //冻结
          Positioned(
              left: 0,
              top: 0,
              width: Utils.setWidth(LayoutConstant.MainWidth),
              height: Utils.setHeight(LayoutConstant.EditHeight),
              child: Offstage(
                  offstage: screenId == -1 || isFreeze == 0 || isFreeze == null,
                  child: Container(
                      color: ColorMap.mask_bkg_color,
                      alignment: Alignment.center,
                      child: GestureDetector(
                          child: Container(
                            child: Image.asset(
                                'assets/images/edit/icon_unfreeze.png'),
                            width: Utils.setWidth(54),
                            height: Utils.setHeight(54),
                          ),
                          onTapDown: (d) {
                            setFreeze();
                          })))),
          // 锁屏
          Positioned(
              left: 0,
              top: 0,
              width: Utils.setWidth(LayoutConstant.MainWidth),
              height: Utils.setHeight(LayoutConstant.EditHeight),
              child: Offstage(
                  offstage: screenId == -1 || isLock == 0 || isLock == null,
                  child: Container(
                      color: ColorMap.mask_bkg_color,
                      alignment: Alignment.center,
                      child: GestureDetector(
                          child: Container(
                            child:
                                Image.asset('assets/images/edit/icon_lock.png'),
                            width: Utils.setWidth(54),
                            height: Utils.setHeight(54),
                          ),
                          onTapDown: (d) {
                            setLock();
                          })))),
        ],
      ),
    );
  }

  //工具栏
  Widget _toolbar(context) {
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    String ftbIconUrl = isBlackScreen
        ? 'assets/images/edit/icon_blackscreen_choice.png'
        : 'assets/images/edit/icon_blackscreen_normal.png';

  
    return Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(Utils.setWidth(15), Utils.setHeight(11),
            Utils.setWidth(15), Utils.setHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                child: Container(
                  margin:
                      EdgeInsets.only(right: Utils.setWidth(toolIconMargin)),
                  child: Image.asset('assets/images/edit/icon_lock_normal.png'),
                  width: Utils.setWidth(toolIconWidth),
                  height: Utils.setHeight(toolIconHeight),
                ),
                onTapDown: (d) {
                  setLock();
                }),
            GestureDetector(
                child: Container(
                  margin:
                      EdgeInsets.only(right: Utils.setWidth(toolIconMargin)),
                  child: Image.asset(ftbIconUrl),
                  width: Utils.setWidth(toolIconWidth),
                  height: Utils.setHeight(toolIconHeight),
                ),
                onTapDown: (d) {
                  setFtb();
                }),
            GestureDetector(
                child: Container(
                  margin:
                      EdgeInsets.only(right: Utils.setWidth(toolIconMargin)),
                  child:
                      Image.asset('assets/images/edit/icon_freeze_normal.png'),
                  width: Utils.setWidth(toolIconWidth),
                  height: Utils.setHeight(toolIconHeight),
                ),
                onTapDown: (d) {
                  setFreeze();
                }),
            GestureDetector(
                child: Container(
                  key: _brightnessIconKey,
                  child: Consumer<EditProvider>(builder:
                    (BuildContext context, data, Widget child) {
                        String brightnessIconUrl =
                          data.currentScreen?.screenBrightness == -1
                              ? 'assets/images/edit/icon_brightness_disable.png'
                              :  data.isBrightnessBtnSel?'assets/images/edit/icon_brightness_choice.png':'assets/images/edit/icon_brightness_normal.png';
                      return  Image.asset(brightnessIconUrl);
                    }),
                  width: Utils.setWidth(toolIconWidth),
                  height: Utils.setHeight(toolIconHeight),
                  margin: EdgeInsets.only(right:  Platform.isIOS ? 0 : Utils.setWidth(toolIconMargin)),
                ),
                onTapDown: (d) {
                  if (editProvider.currentScreen?.screenBrightness == -1) return;
                  editProvider.isBrightnessBtnSel = !editProvider.isBrightnessBtnSel;
                  Navigator.push(
                    context,
                    PopRoute(
                      child: Popup(
                        child: Consumer<EditProvider>(builder:
                            (BuildContext context, data, Widget child) {
                          return _brightnessContainer(data); //
                        }),
                        left: _brightnessIconOffset.dx - Utils.setWidth(brightnessContainerWidth/2) + Utils.setWidth(toolIconWidth/2),//Utils.setWidth(423), //Utils.setWidth(467),
                        top: _brightnessIconOffset.dy - Utils.setWidth(brightnessContainerHeight),//Utils.setHeight(456), //Utils.setHeight(485),
                        onClick: () {
                          print('亮度调节');
                        },
                      ),
                    ),
                  );
                }),
            //关闭视频流
            Offstage(
              offstage: Platform.isIOS? true:false,
              child: Consumer<VideoState>(builder: (BuildContext context, data, Widget child) {
                // bool isVideoClosed = Provider.of<VideoState>(context, listen: false).isVideoClosed;
                String isVideoClosedIconUrl =  data.isVideoClosed!=null && data.isVideoClosed ? 'assets/images/edit/icon_pause_choice.png' : 'assets/images/edit/icon_pause_normal.png';
                return GestureDetector(
                  child: Container(
                    child: Image.asset(isVideoClosedIconUrl),
                    width: Utils.setWidth(toolIconWidth),
                    height: Utils.setHeight(toolIconHeight),
                  ),
                  onTapDown: (d) {
                    bool videoState = data.isVideoClosed==null? true : !data.isVideoClosed;
                    try {
                      EasyLoading.show(status: 'loading...');
                      EasyLoading.instance..maskType = EasyLoadingMaskType.black;

                      if(videoState) {
                        sdk.stopCutTask();
                      } else {
                        executeCutTask(Global.getVideoUrl);
                      }

                      Future.delayed(Duration(seconds: 2), (){ EasyLoading.dismiss(); }); // 延时2s关闭loading
                    } catch(e){
                      print("视频开关时发生异常：$e");
                      EasyLoading.dismiss();
                    }
                    data.isVideoClosed = videoState;
                  });
              },

              ),
            ),
          ],
        ));
  }
  
  // 执行切割任务
  executeCutTask(url) { // , bool videoState
    VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
    sdk.createCutTask(new VideoParam(url)); // displayVideo: videoState?0:1
  }
  //亮度调节slider容器
  Widget _brightnessContainer(EditProvider editProvider) {
    return Container(
      width: Utils.setWidth(brightnessContainerWidth),
      height: Utils.setWidth(brightnessContainerHeight),
      margin: EdgeInsets.only(
          right: Utils.setWidth(LayoutConstant.SplitScrernWidth) / 2),
      // color: Colors.blueAccent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
              width: Utils.setWidth(brightnessContainerWidth),
              height: Utils.setWidth(brightnessContainerSliderHeight),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: ColorMap.header_background,
              ),
              child: new BrightnessSlider(
                  initValue: editProvider.currentScreen != null
                      ? editProvider.currentScreen.screenBrightness
                      : 0,
                  onSliderChanged: onBrightnessSliderChanged)),
          Positioned(
            bottom: Utils.setWidth(1),
            child: Container(
                width: Utils.setWidth(24),
                height: Utils.setWidth(12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        width: Utils.setWidth(triangleWidth),
                        color: ColorMap.header_background, //三角形边框颜色
                      ),
                      left: BorderSide(
                        width: Utils.setWidth(triangleHeight),
                        color: Colors.transparent, //三角形边框颜色
                      ),
                      right: BorderSide(
                        width: Utils.setWidth(triangleHeight),
                        color: Colors.transparent, //三角形边框颜色
                      )),
                )),
          ),
        ],
      ),
    );
  }

  // 设置屏幕冻结
  setFreeze() {
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    int enable = isFreeze == 0 ? 1 : 0;
    try {
        EasyLoading.show(status: 'loading...');
        EasyLoading.instance..maskType = EasyLoadingMaskType.black;
        HttpUtil http = HttpUtil(context).getInstance();
        // final res = await http.request(Api.SET_SCREEN_FREEZE,
        //     data: {'deviceId': 0, 'screenId': screenId, 'enable': enable});
        http.request(Api.SET_SCREEN_FREEZE, data: {
          'deviceId': 0, 
          'screenId': screenId, 
          'enable': enable
        }).then((res){
          if (res.code == 0) {
          // 更新屏幕列表数据
          if (editProvider.currentScreen.freeze != null) {
            editProvider.currentScreen?.freeze?.enable = enable;
          } else {
            editProvider.currentScreen.freeze = new Freeze(enable: enable);
          }
          if (isBlackScreen && enable == 1) {
            isBlackScreen = false;
            if (editProvider.currentScreen.ftb != null) {
              editProvider.currentScreen.ftb.enable = 1;
            } else {
              editProvider.currentScreen.ftb = new Ftb(enable: 1);
            }
          }
          editProvider.forceUpdate();
          setState(() {
            isFreeze = enable;
          });
        }
      }).whenComplete((){
        EasyLoading.dismiss();
      });
    }catch(e){
      EasyLoading.dismiss();
    }
  }

  // 设置屏幕锁屏状态
  setLock() {
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    var enable = isLock == 0 ? 1 : 0;
    setState(() {
      isLock = enable;
    });
    editProvider.currentScreen?.isLock = enable;
    editProvider.forceUpdate();
  }

  //调节屏幕亮度
  void onBrightnessSliderChanged(int pValue) {
    try{
      EasyLoading.show(status: 'loading...');
      EasyLoading.instance..maskType = EasyLoadingMaskType.black;
      HttpUtil http = HttpUtil(context).getInstance();
    // final res = await http.request(Api.SET_SCREEN_BRIGHTNESS,
    //     data: {'deviceId': 0, 'screenId': screenId, 'brightness': pValue});
      http.request(Api.SET_SCREEN_BRIGHTNESS, data: {
      'deviceId': 0, 
      'screenId': 
      screenId, 
      'brightness': pValue
      }).then((res) {
        if (res.code == 0) {
          print("亮度调节成功！");
          Provider.of<EditProvider>(context, listen: false)
              .currentScreen
              .screenBrightness = pValue;
          Provider.of<EditProvider>(context, listen: false).forceUpdate();
        }
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    } catch(e) {
      EasyLoading.dismiss();
    }
  }

  //设置黑屏
  void setFtb() {
    EditProvider editProvider =
        Provider.of<EditProvider>(context, listen: false);
    try {
      EasyLoading.show(status: 'loading...');
      EasyLoading.instance..maskType = EasyLoadingMaskType.black;
      HttpUtil http = HttpUtil(context).getInstance();
      // final res = await http.request(Api.SET_SCREEN_FTB, data: {
      http.request(Api.SET_SCREEN_FTB, data: {  
        'deviceId': 0,
        'screenId': screenId,
        'time': ftbTime,
        'type': isBlackScreen ? 1 : 0
      }).then((res){
        if (res.code == 0) {
          print("黑屏设置成功！");
          editProvider.updateFtbByScreenId(screenId, isBlackScreen ? 1 : 0);
        }
      }).whenComplete((){
        EasyLoading.dismiss();
      });
    } catch(e) {
      EasyLoading.dismiss();
    }
  }
    
}
