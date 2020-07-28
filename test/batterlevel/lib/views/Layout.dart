/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-10 10:17:44
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/views/Init/splash_page.dart';
import 'package:provider/provider.dart';

class ProjectLayout extends StatefulWidget {
  @override
  _ProjectLayoutState createState() => _ProjectLayoutState();
}

class _ProjectLayoutState extends State<ProjectLayout>
    with WidgetsBindingObserver {
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // static const platform = const MethodChannel('com.novastar.io/base');
  
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds:200)).then((e) {
      // getFile();
      getAuth();
    });
    super.initState();
    // initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void deactivate() {
    EasyLoading.dismiss();
    super.deactivate();
    print('deactivate-layout');
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // _connectivitySubscription.cancel();
    print('ProjectLayout dispose');
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

  // // 网路监听进行
  // void _updateConnectionStatus(ConnectivityResult result) {
  //   if (result.toString() == 'ConnectivityResult.none') {
  //     Fluttertoast.showToast(msg: '网络未连接，请检查网络设置', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //if (Global.firstLoad == null) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 假如设计稿是按iPad的尺寸设计的(iPad  1024*768)
    ScreenUtil.init(context, width: 1024.0, height: 768.0);
    Global.firstLoads = false;
    //}
    // print('设备宽度:${ScreenUtil.screenWidth}');
    // print('设备高度:${ScreenUtil.screenHeight}');
    // print('设备像素密度:${ScreenUtil.pixelRatio}');
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      return Scaffold(
        backgroundColor: ColorMap.app_main,
        extendBody: true,
        body: DefaultTextStyle(
          child: SplashPage(),
          style: TextStyle(
            fontSize: Utils.setFontSize(14),
          ),
        ),
      );
    });
  }
  // getFile() async{
  //   String value = await FileHelper.readTime();
  //   print('获取文件的内容-----------$value');
  //   // value = value==''? '10' :value;
  //   if (value == '') {
  //     Provider.of<AuthProvider>(context, listen: false).hasAuthed = false;
  //     Provider.of<AuthProvider>(context, listen: false).remainingTime = 5;//7 * 24 * 60;
  //   } else if (value == '9999') {
  //     Provider.of<AuthProvider>(context, listen: false).hasAuthed = true;
  //   } else {
  //     Provider.of<AuthProvider>(context, listen: false).hasAuthed = false;
  //     Provider.of<AuthProvider>(context, listen: false).remainingTime =
  //         int.parse(value);
  //   }
  // }
  getAuth(){
    if (Global.remainingTime == null) {
      Provider.of<AuthProvider>(context, listen: false).remainingTime = GeneralConstant.ProbationPeriod;
    } else if (Global.remainingTime == GeneralConstant.HasAuthedCode.toString()) {
      Provider.of<AuthProvider>(context, listen: false).remainingTime = GeneralConstant.HasAuthedCode;
    } else {
      Provider.of<AuthProvider>(context, listen: false).remainingTime =
          int.parse(Global.remainingTime);
    }
  }
}
