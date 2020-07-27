/*
 * @Description: Do not edit
 * @Author: benmo
 * @Date: 2020-02-07 11:03:36
 * @LastEditors: haojieyu
 */

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/common/udp.dart';
import 'package:h_pad/models/main/NomarkModeModle.dart';
import 'package:h_pad/states/main/DeviceListProvider.dart';
import 'package:h_pad/states/main/NomarkModeProvider.dart';
import 'package:h_pad/style/colors.dart';
// import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/video/videoplayer.dart';

class InitRouter extends StatelessWidget {
  const InitRouter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //debugDumpRenderTree();
    return InitView();
    // MultiProvider(
    //   providers: [ChangeNotifierProvider(create: (context) => DeviceListProvider())],
    //   child: InitView(),
    // );
  }
}

class InitView extends StatefulWidget {
  @override
  _InitViewState createState() => _InitViewState();
}

class _InitViewState extends State<InitView> with WidgetsBindingObserver {
  Initstates initStatus;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isNetworkAvailable;
  bool _hasUdpConnect = false;
  // static const platform = const MethodChannel('com.novastar.io/base');
  // bool _isSearchingHide = false; // 是否隐藏正在搜索
  Manager manager;
  Timer _timer;
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
  @override
  void initState() {
    print('init初始化');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isNetworkAvailable = true;
    //  manager = Manager(context);
    // initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // sdk.init();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 200), () {
      _refreshDeviceList(context, manager);
    });
  }

  @override
  void didUpdateWidget(InitView oldWidget) {
    Future.delayed(Duration(milliseconds: 200), () {
      _refreshDeviceList(context, manager);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    // EasyLoading.dismiss();
    // if (ModalRoute.of(context).isCurrent) {
    //   Future.delayed(Duration(milliseconds: 200), () {
    //     _refreshDeviceList(context, manager);
    //   });
    // }
    // else {
    // }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    print('注销UDP');
    Manager(context).close(); // 注销udp
    super.dispose();
  }
  // // 网络监听初始化
  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   // 平台消息可能会失败，因此我们使用Try/Catch PlatformException。
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //   // 如果在异步平台消息运行时从树中删除了该小部件，
  //   // 那么我们希望放弃回复，而不是调用setstate来更新我们不存在的外观。
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // 网路监听进行
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result.toString() == 'ConnectivityResult.none') {
      _isNetworkAvailable = false;
      Provider.of<DeviceListProvider>(context,listen: false).displayState = 3;
      Fluttertoast.showToast(
        msg: '网络异常',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: ColorMap.toast_error_color,
        textColor: ColorMap.white,
        gravity: ToastGravity.TOP);
    } else {
      if(!_hasUdpConnect) {
        print('监听到有网=================');
       manager?.close();
       manager = Manager(context);
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          _refreshDeviceList(context, manager);
        });
      }
        _isNetworkAvailable = true;
        _hasUdpConnect = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('initview 又build一遍');
    manager = Manager(context);
    Future.delayed(Duration(milliseconds: 3000)).then((data){
      DeviceListProvider deviceListProvider =Provider.of<DeviceListProvider>(context, listen: false);
      print('3秒后查看设备ip======${deviceListProvider.getDeviceLists.length}');
      int deviceTotal = deviceListProvider.getDeviceLists.length;
      if(deviceTotal > 0){
        print('3秒后查看设备ip -----1======$deviceTotal');
        deviceListProvider.displayState = 1;
      } else {
        print('3秒后查看设备ip -----3======$deviceTotal');
        deviceListProvider.displayState = 3;
      }
    });
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, Utils.setHeight(192), 0, 0),
              child: Image(
                image: AssetImage('assets/images/common/logo.png'),
                width: Utils.setWidth(112.0),
                height: Utils.setHeight(78.0),
              ),
            ),
            //设备列表
            Container(
              margin: EdgeInsets.fromLTRB(0, Utils.setHeight(39), 0, Utils.setHeight(21)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //设备列表
                  Container(
                    margin: EdgeInsets.fromLTRB(Utils.setWidth(24), 0, Utils.setWidth(24), 0),
                    child: Text(
                      '设备列表',
                      style: TextStyle(
                        color: ColorMap.text_normal,
                        fontSize: Utils.setFontSize(24),
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Consumer<DeviceListProvider>(builder: (BuildContext context, data, Widget child) {
                      return Image(
                        image: AssetImage('assets/images/device/icon_refresh.png'),
                        color: data.displayState != 2 ? ColorMap.img_normal : ColorMap.img_disabled,//_isSearchingHide ? ColorMap.img_normal : ColorMap.img_disabled,
                        width: Utils.setWidth(25.6),
                        height: Utils.setHeight(27.6),
                      );
                    }),
                    onTapDown: (d) {
                      _refreshDeviceList(context, manager);
                    },
                  )
                ],
              ),
            ),
            //设备列表
            Container(
              height: Utils.setHeight(174),
              width: Utils.setWidth(360),
              padding: EdgeInsets.symmetric(vertical: Utils.setHeight(3)),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                border: Border.all(color: ColorMap.border_color_split),
                borderRadius: new BorderRadius.all(
                  const Radius.circular(24.0),
                ),
              ),
              child: 
              // _isSearchingHide ? _deviceLists(context) : _isSearchingWidget(context)
              Consumer<DeviceListProvider>(builder: (BuildContext context, data, Widget child) {
                print('再渲染一遍=========${data.displayState}');
                return Stack(children: <Widget>[
                  searchResultWidget(data),
                  deviceList(data),
                  isSearchingTipWidget(data),
                ],);
              }),
            ),
            //手动连接设备
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, Utils.setHeight(39), 0, Utils.setHeight(21)),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ColorMap.text_normal)),
                ),
                child: Text(
                  '手动连接设备',
                  style: TextStyle(
                    color: ColorMap.text_normal,
                    fontSize: Utils.setFontSize(18),
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'PingFangSCRegular',
                  ),
                ),
              ),
              onTapDown: (d) {
                Navigator.pushNamed(context, 'ManualDevice');
                // Navigator.pushNamed(context, 'ManualDevice').then((data){
                //   _refreshDeviceList(context, manager);
                // });
              },
            )
          ],
        ),
      ),
    );
  }
  //设备列表
  Widget deviceList(DeviceListProvider deviceListProvider){
    int deviceTotal = deviceListProvider.getDeviceLists.length;
    print('列表长度-----$deviceTotal');
    return Offstage(
      offstage: deviceListProvider.displayState == 1? false : true,
      child: ListView.separated(
          itemCount: deviceTotal,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      height: Utils.setHeight(54),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: Utils.setWidth(26)),
                      child: Text(
                        "${_getDeviceIP(deviceListProvider.getDeviceLists[index])}",
                        style: TextStyle(
                          color: ColorMap.text_normal,
                          fontSize: Utils.setFontSize(18),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Utils.setWidth(30)),
                    child: Image(
                      image: AssetImage('assets/images/device/icon_arrow.png'),
                      width: Utils.setWidth(13.6),
                      height: Utils.setHeight(24.6),
                      color: ColorMap.border_color_split,
                    ),
                  ),
                ],
              ),
              onTap: () {
                //导航到新路由
                Global.setBaseUrl = "http://${deviceListProvider.getDeviceLists[index]['ip']}";
                Global.setWSUrl = 'ws://${deviceListProvider.getDeviceLists[index]["ip"]}:8080';
                // if (deviceLists.getDeviceLists[index]['status'] == 1) { // 设备初始化完成
                //   _loadDericeInfo(context); // 测试设备状态
                // } else if (deviceLists.getDeviceLists[index]['status'] == 0) { // 设备初始化未完成
                //   Fluttertoast.showToast(
                //     msg: '设备初始化中，请稍后重试',
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.TOP);
                // } else {
                //   return;
                // }
                _loadDericeInfo(context); // 测试设备状态
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: Utils.setHeight(1),
              color: ColorMap.border_color_split,//ColorMap.text_normal,
              indent: Utils.setWidth(24),
              endIndent: Utils.setWidth(24),
            );
          },
        ),
      );
  }
  //搜索中
  Widget isSearchingTipWidget(DeviceListProvider deviceListProvider){
    return Offstage(
      offstage: deviceListProvider.displayState == 2 ? false : true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorMap.noDevice_font),
                strokeWidth: Utils.setWidth(2),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: Utils.setHeight(10)),
              child: Text('搜索中...',
                style: TextStyle(
                  color: ColorMap.noDevice_font,
                  fontSize: Utils.setFontSize(18),
                  decoration: TextDecoration.none,
                  fontFamily: 'PingFangSCRegular',
                )
              ),
            ),
          ],
        ),
      ),
      // child: Center(
      //   child: Text('搜索中...',
      //     style: TextStyle(
      //       color: ColorMap.noDevice_font,
      //       fontSize: Utils.setFontSize(18),
      //       decoration: TextDecoration.none,
      //       fontFamily: 'PingFangSCRegular',
      //     )
      //   )
      // ),
    );
  }
  //搜索结果部件
  Widget searchResultWidget(DeviceListProvider deviceListProvider){
    return Offstage(
      offstage: deviceListProvider.displayState == 3 ? false : true,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('无法搜索到设备，',
                style: TextStyle(
                  color: ColorMap.noDevice_font,
                  fontSize: Utils.setFontSize(18),
                  decoration: TextDecoration.none,
                  fontFamily: 'PingFangSCRegular',
                )
              ),
              Text('请尝试手动连接设备。',
                style: TextStyle(
                  color: ColorMap.noDevice_font,
                  fontSize: Utils.setFontSize(18),
                  decoration: TextDecoration.none,
                  fontFamily: 'PingFangSCRegular',
                )
              )
            ],
          ),
        ),
    );
  }


  _refreshDeviceList(context, Manager manager) {
    print('刷新======发送消息');
    DeviceListProvider deviceListProvider = Provider.of<DeviceListProvider>(context, listen: false);
    if(_isNetworkAvailable) {
      deviceListProvider.displayState = 2;
      // Provider.of<DeviceListProvider>(context, listen: false).clearDevice();
      if(manager == null){
        manager = Manager(context);
      }
      manager.onceAgain();
      Future.delayed(Duration(milliseconds: 3000)).then((data){
        // print('3秒后查看设备ip======${deviceListProvider.getDeviceLists.length}');
        int deviceTotal = deviceListProvider.getDeviceLists.length;
        if(deviceTotal > 0){
          // print('3秒后查看设备ip -----1======$deviceTotal');
          deviceListProvider.displayState = 1;
        } else {
          // print('3秒后查看设备ip -----3======$deviceTotal');
          deviceListProvider.displayState = 3;
        }
      });
    } else {
      deviceListProvider.displayState = 3;
      //搜索框内有提示，不需要飘窗提示
      
      // Fluttertoast.showToast(
      //   msg: '网络未连接，请检查网络设置',
      //   toastLength: Toast.LENGTH_SHORT,
      //   backgroundColor: ColorMap.toast_error_color,
      //   textColor: ColorMap.white,
      //   gravity: ToastGravity.TOP);
     print('网络不可用--------清除provider');
        Provider.of<DeviceListProvider>(context, listen: false).clearDevice();
    }
  }

  // 获取设备IP 返回值 "H2 IP: 192.168.10.111"
  _getDeviceIP(deviceInfo) {
    String deviceDype = 'H9';
    if(deviceInfo['data']['modeId'] == 29965) {
      deviceDype = 'H2';
    } else if(deviceInfo['data']['modeId'] == 29962) {
      deviceDype = 'H9';
    } else if(deviceInfo['data']['modeId'] == 29963) {
      deviceDype = 'H5';
    }
    return "$deviceDype IP: ${deviceInfo['ip']}";
  }

  // states 查询设备状态
  void _loadDericeInfo(context) {
    // showLoadingDialog(context);
    EasyLoading.show(status: 'loading...');
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    HttpUtil http = HttpUtil(context).getInstance(isNewDevice: true);
    http.request(Api.INIT_STATUS, data: {'deviceId': 0}).then((res) {
      // Navigator.of(context).pop();
      EasyLoading.dismiss();
      if (res.code == 0) {
        initStatus = Initstates.fromJson(res.data);
        if (initStatus.initStatus != 1) {
          // 设备无法登录
        }
        // todo:  initStatus.languageMode 语言模式
        // initStatus.nomarkMode  中性信息
        _getLoginStatus(context, initStatus);
        print('查询设备状态，清除provider');
        Provider.of<DeviceListProvider>(context, listen: false).clearDevice();
        Provider.of<DeviceListProvider>(context, listen: false).displayState = 3;
        // Navigator.pushNamed(context, 'Login');
        // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
        //   return new LoginRoute();
        // }));
        // 跳转登录并关闭当前页面
        // Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => new LoginRoute()), (route) => route == null );
        Navigator.pushNamed(context, 'Login').then((data){
          _refreshDeviceList(context, manager);
        });
      }
    }).catchError((err) {
      // Navigator.of(context).pop();
      EasyLoading.dismiss();
      print('errInitView: $err');
    });
  }

  //中性状态
  void _getLoginStatus(BuildContext context, Initstates objInfo) async {
    if (objInfo.nomarkMode != null) {
      final nomarkModeInfo = NomarkModeInfo.fromJson(objInfo.nomarkMode);
      Provider.of<NomarkModeProvider>(context, listen: false).nomarkModeInfo = nomarkModeInfo;
    }
  }
}
