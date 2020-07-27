/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-29 18:21:01
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-08 18:05:57
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/util_index.dart';
import 'package:device_info/device_info.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:h_pad/widgets/CopyToolbar.dart';
import 'package:provider/provider.dart';

class AuthorizationView extends StatefulWidget {
  @override
  _AuthorizationViewState createState() => _AuthorizationViewState();
}

class _AuthorizationViewState extends State<AuthorizationView>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  FocusNode authFocusNode = new FocusNode();
  String uuid = '';
  static String serialId = '';
  bool isPointerDown = false;
  int pointerDownStamp;
  TextEditingController _authController = TextEditingController.fromValue(
      TextEditingValue(
          // 设置内容
          text: serialId,
          // 保持光标在最后
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream, offset: serialId.length))));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getDeviceInfo();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback(_handlePostFrame);
    super.didChangeMetrics();
  }

  void _handlePostFrame(Duration timeStamp) {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomPadding: true,
        extendBody: false,
        body: Container(
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.transparent, //ColorMap.modal_mask,
            child: new SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorMap.bkg_auth,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(14.0),
                  ),
                ),
                height: Utils.setWidth(280),
                width: Utils.setWidth(682),
                child: Stack(
                  // alignment: Alignment.center,
                  children: <Widget>[
                    // Center(
                    //   child:
                    Container(
                      padding: EdgeInsets.fromLTRB(Utils.setWidth(20),
                          Utils.setWidth(23), Utils.setWidth(20), 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text('授权',
                                style: TextStyle(
                                    fontSize: Utils.setFontSize(18),
                                    fontWeight: FontWeight.bold,
                                    color: ColorMap.txt_font_color)),
                          ),
                          Container(
                            width: Utils.setWidth(682),
                            child: Form(
                              // key: _formKey,
                              autovalidate: true,
                              child: Column(
                                children: <Widget>[
                                  _serialNumberText(),
                                  Stack(
                                    children: <Widget>[
                                      _authorizationCodeText(),
                                      Positioned(
                                        left: Utils.setWidth(50),
                                        top: Utils.setWidth(0),
                                        child: Consumer<AuthProvider>(builder:
                                            (BuildContext context, data,
                                                Widget child) {
                                          return Offstage(
                                            offstage: !data.isCopyToolbarShow,
                                            child: CopyToolbar(
                                                paste: pasteAuthCode),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                  //  Loading(indicator: BallPulseIndicator(), size: 100.0, color: Colors.pink),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // ),
                    Positioned(
                        top: Utils.setWidth(232),
                        left: 0,
                        child: Container(
                          width: Utils.setWidth(682),
                          // height: Utils.setWidth(55),
                          // color: Colors.red,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                          top: BorderSide(
                                            color: ColorMap.border_auth,
                                          ),
                                          right: BorderSide(
                                            color: ColorMap.border_auth,
                                          ))),
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        Utils.setWidth(10),
                                        0,
                                        Utils.setWidth(10)),
                                    autofocus: false,
                                    child: Text('取消',
                                        style: TextStyle(
                                            fontSize: Utils.setFontSize(18),
                                            color: ColorMap.btn_auth)),
                                    onPressed: () async {
                                      var remainingTime =
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .remainingTime;
                                      if (remainingTime > 0) {
                                        // Navigator.of(context).pop();
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .tipCode = -1;
                                      } else {
                                        // Navigator.of(context).pop();
                                        // await Exit.pop(animated:true);
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .tipCode = -1;
                                        exit(0);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                        top: BorderSide(
                                          color: ColorMap.border_auth,
                                        ),
                                      )),
                                  child: FlatButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Utils.setWidth(10)),
                                    autofocus: false,
                                    child: Text('授权',
                                        style: TextStyle(
                                            fontSize: Utils.setFontSize(18),
                                            color: ColorMap.btn_auth)),
                                    onPressed: () {
                                      bool isAuth = encryption();
                                      if (isAuth) {
                                        // FileHelper.setLocalFile('9999');
                                        Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .remainingTime =
                                            GeneralConstant.HasAuthedCode;
                                        Global.saveAuthTime(
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .remainingTime
                                                .toString());
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .tipCode = -1;
                                        // Navigator.of(context).pop();
                                        print('授权成功，关闭当前');
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: '授权码错误',
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor:
                                                ColorMap.toast_error_color,
                                            textColor: ColorMap.white,
                                            gravity: ToastGravity.TOP);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }

  //设备ID
  Widget _serialNumberText() {
    return Container(
      margin: EdgeInsets.only(top: Utils.setWidth(30)),
      height: Utils.setWidth(36),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: Utils.setWidth(12)),
            child: Image(
              image: AssetImage('assets/images/device/icon_pad.png'),
              width: Utils.setWidth(24),
              height: Utils.setWidth(24),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('设备ID：$uuid',
                  style: TextStyle(
                      fontSize: Utils.setFontSize(18),
                      color: ColorMap.txt_font_color)),
            ),
          ),
          Container(
            width: Utils.setWidth(72),
            height: Utils.setWidth(36),
            decoration: BoxDecoration(
              border: Border.all(color: ColorMap.txt_font_color),
              borderRadius: new BorderRadius.all(
                const Radius.circular(4.0),
              ),
            ),
            child: FlatButton(
              color: Colors.transparent,
              padding: EdgeInsets.all(0),
              textColor: ColorMap.version_font,
              // disabledColor: Colors.grey,
              // disabledTextColor: ColorMap.version_font,
              // focusColor: ColorMap.bkg_auth,
              // splashColor: ColorMap.bkg_auth,
              onPressed: () async {
                if (uuid == null) {
                  Fluttertoast.showToast(
                      msg: '没有内容可以复制',
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: ColorMap.toast_error_color,
                      textColor: ColorMap.white,
                      gravity: ToastGravity.TOP);
                  return;
                }
                Clipboard.setData(ClipboardData(text: '${uuid.trim()}'));
                Fluttertoast.showToast(
                    msg: '复制成功',
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: ColorMap.toast_error_color,
                    textColor: ColorMap.white,
                    gravity: ToastGravity.TOP);
              },
              child: Text(
                "复制",
                style:
                    TextStyle(fontSize: 16.0, color: ColorMap.txt_font_color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //设备授权码
  Widget _authorizationCodeText() {
    return Container(
      margin: EdgeInsets.only(top: Utils.setWidth(27)),
      height: Utils.setHeight(50),
      child: Listener(
        child: TextField(
          autofocus: false,
          focusNode: authFocusNode,
          controller: _authController,
          keyboardType: TextInputType.text,
          enableInteractiveSelection: false,
          style: TextStyle(
            color: ColorMap.txt_font_color,
            fontSize: Utils.setFontSize(18),
          ),
          decoration: InputDecoration(
            fillColor: ColorMap.input_bg_auth,
            filled: true,
            contentPadding: EdgeInsets.all(0),
            hintText:
                "请输入授权码", //Translations.of(context).text('login.AccountPlaceholder'),
            hintStyle: TextStyle(
              color: ColorMap.version_font,
              fontSize: Utils.setFontSize(18),
            ),
            prefixIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: Utils.setWidth(12)),
              height: Utils.setWidth(24),
              width: Utils.setWidth(24),
              child: Image(
                image: AssetImage('assets/images/device/icon_keys2.png'),
              ),
            ),
            // 未获得焦点下划线设为灰色
            enabledBorder: OutlineInputBorder(
              /*边角*/
              borderRadius: BorderRadius.all(
                Radius.circular(8), //边角为30
              ),
              borderSide: BorderSide(
                color: ColorMap.border_auth, //边线颜色为黄色
                width: 1, //边线宽度为2
              ),
            ),
            //获得焦点下划线设为灰色
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8), //边角为30
              ),
              borderSide: BorderSide(
                color: ColorMap.border_auth, //边线颜色为黄色
                width: 1, //边线宽度为2
              ),
            ),
            suffixIcon: Container(
                width: Utils.setWidth(70),
                height: Utils.setWidth(18),
                // margin: EdgeInsets.only(right: Utils.setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: new IconButton(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: Utils.setWidth(6)),
                        icon: Icon(Icons.cancel,
                            color: ColorMap.version_font), //ColorMap.del_font
                        iconSize: Utils.setFontSize(20),
                        onPressed: () {
                          setState(() {
                            _authController.text = '';
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ),
          // maxLength: 20,
          // maxLengthEnforced: false,
          inputFormatters: [LengthLimitingTextInputFormatter(36)],
          onEditingComplete: () {},
          onTap: () {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isCopyToolbarShow) {
              Provider.of<AuthProvider>(context, listen: false)
                  .isCopyToolbarShow = false;
            }
          },
        ),
        onPointerDown: (PointerDownEvent e) async {
          isPointerDown = true;
          int temp = new DateTime.now().millisecondsSinceEpoch;
          pointerDownStamp = temp;
          Future.delayed(Duration(seconds: 1), () async {
            if (isPointerDown && temp == pointerDownStamp) {
              ClipboardData data =
                  await Clipboard.getData(Clipboard.kTextPlain);
              if (data != null) {
                Provider.of<AuthProvider>(context, listen: false)
                    .isCopyToolbarShow = true;
                // authFocusNode.unfocus();
              }
            }
          });
        },
        onPointerUp: (PointerUpEvent e) {
          isPointerDown = false;
          pointerDownStamp = new DateTime.now().millisecondsSinceEpoch;
        },
      ),
    );
  }

  void pasteAuthCode(data) {
    Provider.of<AuthProvider>(context, listen: false).isCopyToolbarShow = false;
    if (data != null) {
      setState(() {
        _authController.text = data.text;
        _authController.selection = TextSelection(
            baseOffset: data.text.length, extentOffset: data.text.length);
      });
    }
  }

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print(_readAndroidBuildData(androidInfo).toString());
      uuid = _readAndroidBuildData(androidInfo)['androidId'].toString();
      setState(() {
        uuid = uuid;
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print(_readIosDeviceInfo(iosInfo).toString());
      uuid = _readIosDeviceInfo(iosInfo)['identifierForVendor'].toString();
      setState(() {
        uuid = uuid;
      });
    }
  }

  //读取Android设备信息
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId
    };
  }

  //读取IOS设备信息
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  bool encryption() {
    String authTxt = _authController.text;
    String str = uuid;
    if (str == null || str == '') return false;
    String middleStr = '';
    String retStr = '';
    for (int i = 0; i < str.length; i++) {
      middleStr = middleStr + str[str.length - i - 1];
    }
    int ascii = middleStr.codeUnitAt(0);
    if (ascii % 2 == 0) {
      for (int i = 0; i < middleStr.length; i++) {
        String tempStr = (i + 1) % 2 == 0 ? '6' : middleStr[i];
        retStr = retStr + tempStr;
      }
    } else {
      for (int i = 0; i < middleStr.length; i++) {
        String tempStr = (i + 1) % 2 != 0 ? '3' : middleStr[i];
        retStr = retStr + tempStr;
      }
    }
    var t = md5.convert(utf8.encode(retStr));
    retStr = hex.encode(t.bytes) + '01';
    if (authTxt == retStr) return true;
    return false;
  }
}
