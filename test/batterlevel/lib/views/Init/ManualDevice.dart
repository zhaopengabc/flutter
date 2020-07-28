/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-25 14:47:35
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-18 21:03:34
 */ 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/api/http.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/common/regExp.dart';
import 'package:h_pad/models/main/NomarkModeModle.dart';
import 'package:h_pad/models/profile/initstates.dart';
import 'package:h_pad/states/main/MenualDeviceProvider.dart';
import 'package:h_pad/states/main/NomarkModeProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/utils/utils.dart';
// import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ManualDevice extends StatefulWidget {
  @override
  _ManualDeviceState createState() => _ManualDeviceState();
}

class _ManualDeviceState extends State<ManualDevice>  with WidgetsBindingObserver {
  var style = TextStyle(
    color: ColorMap.text_normal,
    fontSize: Utils.setFontSize(18)
  );
  var inputDecoration = InputDecoration(
    // // 未获得焦点下划线设为灰色·
    // enabledBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: ColorMap.app_main),
    // ),

    // // 获得焦点下划线设为蓝色
    // focusedBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: ColorMap.app_main),
    // ),
    contentPadding: EdgeInsets.only(top:Utils.setHeight(20)),
    border: InputBorder.none
  );

  //定义一个controller
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller0 = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  String ip;
  // bool _showFocus = true;
  Initstates initStatus;
  //输入框焦点管理对象
  FocusNode textFocusNode = new FocusNode();
  FocusNode textFocusNode0 = new FocusNode();
  FocusNode textFocusNode1 = new FocusNode();
  FocusNode textFocusNode2 = new FocusNode();
  FocusNode textFocusNode3 = new FocusNode();
  //管理输入框焦点对象的对象
  FocusScopeNode focusScopeNode;
  final _scrollController = ScrollController();

  // 设备IP连接按钮状态, true-可点击，false-不可点击
  // bool _isConnectDisabled = true;

  @override
  void initState() {
    // _isConnectDisabled = true;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //输入框件添加（注册）监听器，用于检测输入框内内容的变化
    textFocusNode.addListener(() {
      if (textFocusNode.hasFocus) {
        // TextField has lost focus
        // setState(() {
          // _showFocus = true;
          textFocusNode.unfocus();
          textFocusNode0.requestFocus();
          // Future.delayed(Duration(milliseconds: 100), () {
          //   textFocusNode.unfocus();
          //   textFocusNode0.requestFocus();
          // });
        // });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    WidgetsBinding.instance.removeObserver(this);
    textFocusNode.dispose();
    textFocusNode0.dispose();
    textFocusNode1.dispose();
    textFocusNode2.dispose();
    textFocusNode3.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback(_handlePostFrame);
    super.didChangeMetrics();
  }

  void _handlePostFrame(Duration timeStamp) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMap.app_main,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(backgroundColor: ColorMap.app_main),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage('assets/images/common/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        child:Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, Utils.setHeight(102), 0, 0),
                child: Image(
                  image: AssetImage('assets/images/common/logo.png'),
                  width: Utils.setWidth(112.0),
                  height: Utils.setHeight(78.0),
                ),
              ),
              Container(
                width: Utils.setWidth(320),
                margin: EdgeInsets.fromLTRB(0, Utils.setHeight(24), 0, Utils.setHeight(24)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorMap.border_color_bottomLine,
                      width: Utils.setWidth(2),
                    ),
                  ),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _text0(),
                    _point(),
                    _text1(),
                    _point(),
                    _text2(),
                    _point(),
                    _text3(),
                  ],
                )
              ),
              Container(
                // margin: EdgeInsets.only(top: Utils.setHeight(15)),
                margin: EdgeInsets.fromLTRB(0, Utils.setHeight(15), 0, Utils.setHeight(15)),
                width: Utils.setWidth(320),
                height: Utils.setHeight(55),
                child: Consumer<MenualDeviceProvider>(builder: (BuildContext context, data, Widget child) {
                  return RaisedButton(
                    child: Text('连接',style: TextStyle(fontSize: Utils.setFontSize(18)),),
                    color:data.isConnectDisabled ? Theme.of(context).primaryColor : ColorMap.button_disabled_color,
                    textColor: Colors.white,
                    padding: EdgeInsets.only(left: Utils.setWidth(6)),
                    onPressed: () {
                      if (!data.isConnectDisabled) {
                        return;
                      }
                      // setState(() {
                      //   _isConnectDisabled = false;
                      // });
                      // 关闭软键盘
                      textFocusNode0.unfocus();
                      textFocusNode1.unfocus();
                      textFocusNode2.unfocus();
                      textFocusNode3.unfocus();
                      if (ipcheck()) {
                        data.isConnectDisabled = false;
                        Global.setBaseUrl = "http://$ip";
                        _loadDericeInfo(context); // 测试 设备状态
                      }
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),),
    );
  }

  Widget _text() {
    return TextField(
      autofocus: false,
      focusNode: textFocusNode,
      enableInteractiveSelection: false,
      style: style,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '请输入设备IP地址',
        hintStyle: TextStyle(
          color: ColorMap.text_normal,
          fontSize: Utils.setFontSize(18),
        ),
        // 未获得焦点下划线设为灰色·
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMap.app_main),
        ),

        ///获得焦点下划线设为蓝色
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMap.app_main),
        ),
      ),
      controller: _controller,
    );
  }

  Widget _text0() {
    return Expanded(
      flex: 1,
      child: TextField(
        autofocus: true,
        focusNode: textFocusNode0,
        enableInteractiveSelection: false,
        style: style,
        textAlign: TextAlign.center,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
        keyboardType: TextInputType.number,
        decoration: inputDecoration,
        controller: _controller0,
        onChanged: (v) {
          if (v != null) {
            if (num.parse(v) > 223 || !RegExp(RegExps.abcRegex).hasMatch(v) || v == '127') {
              _controller0.text = v.substring(0, v.length - 1);
              _controller1.text = v.substring(v.length - 1, v.length);
              textFocusNode1.requestFocus();
            }
            // else if (!RegExp(RegExps.abcRegex).hasMatch(v) || v == '127') {
            //   _controller0.text = v.substring(0, v.length - 1);
            //   textFocusNode1.requestFocus();
            // }
          }
        },
        onEditingComplete: () {
          textFocusNode0.unfocus();
          textFocusNode1.requestFocus();
        },
      ),
    );
  }

  Widget _text1() {
    return Expanded(
      flex: 1,
      child: TextField(
        style: style,
        textAlign: TextAlign.center,
        focusNode: textFocusNode1,
        enableInteractiveSelection: false,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
        controller: _controller1,
        keyboardType: TextInputType.number,
        decoration: inputDecoration,
        onChanged: (v) {
          if (v != null) {
            if (!RegExp(RegExps.ipRegex).hasMatch(v)) {
              _controller1.text = v.substring(0, v.length - 1);
              _controller2.text = v.substring(v.length - 1, v.length);
              textFocusNode2.requestFocus();
            }
          }
        },
        onEditingComplete: () {
          textFocusNode1.unfocus();
          textFocusNode2.requestFocus();
        },
      ),
    );
  }

  Widget _text2() {
    return Expanded(
      flex: 1,
      child: TextField(
        style: style,
        textAlign: TextAlign.center,
        focusNode: textFocusNode2,
        enableInteractiveSelection: false,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
        controller: _controller2,
        keyboardType: TextInputType.number,
        decoration: inputDecoration,
        onChanged: (v) {
          if (v != null) {
            if (!RegExp(RegExps.ipRegex).hasMatch(v)) {
              _controller2.text = v.substring(0, v.length - 1);
              _controller3.text = v.substring(v.length - 1, v.length);
              textFocusNode3.requestFocus();
            }
          }
        },
        onEditingComplete: () {
          textFocusNode2.unfocus();
          textFocusNode3.requestFocus();
        },
      ),
    );
  }

  Widget _text3() {
    return Expanded(
      flex: 1,
      child: TextField(
        style: style,
        textAlign: TextAlign.center,
        focusNode: textFocusNode3,
        enableInteractiveSelection: false,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
        controller: _controller3,
        keyboardType: TextInputType.number,
        decoration: inputDecoration,
        onChanged: (v) {
          if (v != null) {
            if (!RegExp(RegExps.ipRegex).hasMatch(v)) {
              _controller3.text = v.substring(0, v.length - 1);
            }
          }
        },
        onEditingComplete: () {
          textFocusNode3.unfocus();
        },
      ),
    );
  }

  Widget _point() {
    return Padding(
      padding: EdgeInsets.only(bottom: Utils.setHeight(4)),
      child: Text(
        '.',
        style: TextStyle(
          fontSize: Utils.setFontSize(36),
          color: ColorMap.text_normal,
          decoration: TextDecoration.none,
          height: Utils.setHeight(2),
        ),
      ),
    );
  }

  bool ipcheck() {
    //导航到新路由
    String v = '${_controller0.text}.${_controller1.text}.${_controller2.text}.${_controller3.text}';
    if (!new RegExp(RegExps.ip_Normal).hasMatch(v)) {
      Fluttertoast.showToast(
        msg: 'IP格式校验错误',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return false;
    } else if (_controller1.text == '255' && _controller2.text == '255' && _controller3.text == '255' ||
        _controller1.text == '0' && _controller2.text == '0' && _controller3.text == '0') {
      _controller3.text = '1';
      Fluttertoast.showToast(
        msg: 'IP格式校验错误',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return false;
    }
    ip = v;
    return true;
  }

  // states 查询设备状态
  void _loadDericeInfo(context) {
    // EasyLoading.show(status: 'loading...');
    // EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.show(status: 'loading...');
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    // showLoadingDialog(context);
    HttpUtil http = HttpUtil(context).getInstance(isNewDevice: true);
    http.request(Api.INIT_STATUS, data: {'deviceId': 0}, passCodeList: [50002]).then((res) {
      // Navigator.of(context).pop();
     
      if (res.code == 0) {
        initStatus = Initstates.fromJson(res.data);
        if (initStatus.initStatus != 1) {
          // 设备无法登录
        }
        // todo:  initStatus.languageMode 语言模式
        // initStatus.nomarkMode  中性信息
        _getLoginStatus(context, initStatus);
        // 建立socket 连接
        Global.setWSUrl = 'ws://$ip:8080';
        ip = '';
        Navigator.pushNamed(context, 'Login');
        // Navigator.of(context).pushReplacementNamed('Login');message.http${res.code}
      } else {
        // print('333333333333-----------${res.msg}----${res.code}---}');
        // String msg = Translations.of(context)
        //         .text("message.http${res.code}");
        if(res.code==50002){
          Fluttertoast.showToast(
            msg: '未检测到设备',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: ColorMap.toast_error_color,
            textColor: ColorMap.white,
            gravity: ToastGravity.TOP,
          );
        }
      }
    }).catchError((err) {
      // Navigator.of(context).pop();
      EasyLoading.dismiss();
      print('err: $err');
    }).whenComplete(() {
      // setState(() {
      //   _isConnectDisabled = true; // 连接按钮可用
      // });
      Provider.of<MenualDeviceProvider>(context, listen: false).isConnectDisabled = true;
      EasyLoading.dismiss();
      // Navigator.of(context).pop();
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
