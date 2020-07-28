import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:h_pad/common/file_operation.dart';
import 'package:h_pad/i18n/application.dart';
import 'package:h_pad/i18n/translation.dart';
import 'package:h_pad/routes/index.dart';
import 'package:h_pad/states/common/ProfileChangeNotifier.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:h_pad/states/main/DeviceListProvider.dart';
import 'package:h_pad/states/main/LoginProvider.dart';
import 'package:h_pad/states/main/MenualDeviceProvider.dart';
import 'package:h_pad/states/main/NomarkModeProvider.dart';
import 'package:h_pad/states/main/UserProvider.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/ChineseCupertinoLocalizations.dart';
import 'package:h_pad/utils/flie_operation.dart';
import 'package:h_pad/views/Layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'common/global.dart';
import 'i18n/local/localization_delegate.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportError(details);
  };

  Global.init().then((e) => {
        // debugPaintSizeEnabled = true, // 可视方式调试布局问题
        runZoned(() {
          // 强制横屏
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]).then((_) {
            runApp(H9pad());
            if (Platform.isAndroid) {
              // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
              SystemUiOverlayStyle systemUiOverlayStyle =
                  SystemUiOverlayStyle(statusBarColor: Colors.transparent);
              SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
              SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
            }
          });
          // return runApp(H9pad());
        }, onError: (Object error, StackTrace stack) {
          print('error主入口异常捕获报错: $error');
          print('stack主入口异常捕获: $stack');
          // var details=makeDetails(error, stack);
          // reportError(details);
        })
      });
}

//状态了隐藏/显示控制
// void toggleFullscreen() {
//   _isFullscreen = !_isFullscreen;
//   _isFullscreen
//       ? SystemChrome.setEnabledSystemUIOverlays([])
//       : SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
// }
reportError(FlutterErrorDetails details) async {
  print('程序异常$details');
  // await Storage.writeCounter('$details');
}

class H9pad extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // if (Global.firstLoad == null) {
    //   //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    //   if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
    //     ScreenUtil.init(context, width: 1920, height: 1080);
    //   } else {
    //     ScreenUtil.init(context, width: 1080, height: 1920);
    //   }
    //   Global.firstLoad = 'false';
    // }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: NomarkModeProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: DeviceListProvider()),
        ChangeNotifierProvider.value(value: MenualDeviceProvider()),
        ChangeNotifierProvider.value(value: LoginProvider()),
        ChangeNotifierProvider.value(value: UserNames()),
        ChangeNotifierProvider.value(value: EditProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
          return FlutterEasyLoading(
              child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '可视化终端',
            color: ColorMap.body_bg,
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              const TranslationsDelegate(),
              ChineseCupertinoLocalizations.delegate, // 这里加上这个,是自定义的delegate
              // AppLocalizationsDelegate.delegate,
              DefaultCupertinoLocalizations.delegate, // 这个截止目前只包含英文
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // Routers.routers(context)
            routes: Routers.routers(context),
            supportedLocales: applic.supportedLocales(),
            home: ProjectLayout(),
            locale: localeModel.getLocale(),
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                Locale locale;
                //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('zh', 'CN');
                  //使用美国英语  locale = Locale('en', 'US');
                }
                return locale;
              }
            },
            //  我们有了一个全局的APPLIC类来存放设置
            //  home: Global.firstLoad == null ? PrivacyAgreement() : MyHomePage() //如果没有弹出过隐私协议则进入隐私协议界面
            //)
          ));
        },
      ),
    );
  }
}
//WillPopScope 监听系统返回键
