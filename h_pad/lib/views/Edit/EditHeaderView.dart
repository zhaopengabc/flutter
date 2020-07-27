// 顶部 Logo、屏幕 列表、登录账号
import 'package:flutter/material.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/api/websocket/index.dart';
import 'package:h_pad/common/PopupRoute.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/states/main/NomarkModeProvider.dart';
import 'package:h_pad/states/main/UserProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/utils/util_index.dart';
import 'package:h_pad/views/Edit/screenList/ScreenListView.dart';
import 'package:h_pad/widgets/LogoutPopupWidget.dart';
import 'package:provider/provider.dart';

class EditHeaderView extends StatefulWidget {
  final WebSocketUtil webSocketUtil;
  EditHeaderView(this.webSocketUtil);
  @override
  _EditHeaderViewState createState() => _EditHeaderViewState();
}

class _EditHeaderViewState extends State<EditHeaderView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorMap.header_background,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: Utils.setFontSize(14),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: Utils.setWidth(LayoutConstant.PresetListWidth),
              child: Container(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    (Consumer<NomarkModeProvider>(builder: (BuildContext context, data, Widget child) {
                      return Container(
                        // color: Colors.red,
                          margin: EdgeInsets.fromLTRB(Utils.setWidth(19), Utils.setHeight(8), 0, Utils.setHeight(8)),
                          child: _logo(data));
                    }))
                  ],
                ),
              ),
            ),
            Expanded(
              // flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: Utils.setHeight(48.1)),
                height: Utils.setHeight(80),
                // color: Colors.yellow,
                padding: EdgeInsets.all(0.0),
                child: ScreenListView(),
              ),
            ),
            Container(
              child: (Consumer<UserProvider>(builder: (BuildContext context, data, Widget child) {
                return GestureDetector(
                  child: _userWidget(data),
                  onTap: () {
                    _logoutVisible(context, widget.webSocketUtil);
                  },
                );
              })),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo(NomarkModeProvider data) {
    if (data.nomarkModeInfo?.nomarkMode == 2) {
      return '${Global.getBaseUrl}' != 'null' && '${data.nomarkModeInfo?.logo}' != 'null'
          ? Image.network(
              '${Global.getBaseUrl}${data.nomarkModeInfo.logo}',
              //'assets/images/edit/img_logo_caption.png',
              // width: Utils.setWidth(57), ////图片的宽
              height: Utils.setHeight(38.0), //图片高度
              alignment: Alignment.centerLeft, //对齐方式
              repeat: ImageRepeat.noRepeat, //重复方式
              // fit: BoxFit.fitHeight, //fit缩放模式
            )
          : null;
    } else if (data.nomarkModeInfo?.nomarkMode == 0) {
      return Image.asset(
        'assets/images/edit/img_logo_caption.png',
        width: Utils.setWidth(57), ////图片的宽
        height: Utils.setHeight(38.0), //图片高度
        alignment: Alignment.centerLeft, //对齐方式
        repeat: ImageRepeat.noRepeat, //重复方式
        fit: BoxFit.fitHeight, //fit缩放模式
      );
    } else {
      return null;
    }
  }

  //用户登录widget
  Widget _userWidget(UserProvider userProvider) {
    return Container(
      width: Utils.setWidth(141),
      height: Utils.setHeight(54),
      color: ColorMap.user_background,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Positioned(
            left: Utils.setWidth(16.4),
            child: Image.asset(
              'assets/images/edit/icon_user.png',
              width: Utils.setWidth(17.4), ////图片的宽
              height: Utils.setHeight(20), //图片高度
              alignment: Alignment.centerLeft, //对齐方式
              repeat: ImageRepeat.noRepeat, //重复方式
              fit: BoxFit.fitHeight, //fit缩放模式
            ),
          ),
          //${data.currentUserExtral?.userName}
          Positioned(
            left: Utils.setWidth(40.96),
            child: Container(
              width: Utils.setWidth(84),
              child: Text(
                  '${userProvider.currentUser}' == 'null' || '${userProvider.currentUser.userName}' == 'null'
                      ? ""
                      : '${userProvider.currentUser?.userName}',
                  style: TextStyle(
                    color: ColorMap.user_font_color,
                    // fontSize: Utils.setFontSize(14),
                  ),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }

//登出按钮显示/隐藏
  void _logoutVisible(context, WebSocketUtil webSocketUtil) async {
    // setState(() {
    //   logOutVisible = !logOutVisible;
    // });
    // webSocketUtil = WebSocketUtil.getInstance();
    Navigator.push(
      context,
      PopRoute(
        child: LogoutPopup(
          child: _logoutBtn(context),
          left: Utils.setWidth(869), //Utils.setWidth(295 + 156),
          top: Utils.setHeight(LayoutConstant.HeadHeight), //Utils.setHeight(485),
          onClick: () async {
            HttpUtil http = HttpUtil(context).getInstance();
            http.request(Api.LOGOUT, passCodeList: [60000]);
            Global.setToken = "";
            // Navigator.pushNamed(context, 'Login');
            Provider.of<EditProvider>(context, listen: false).screenList = new List();
            Provider.of<EditProvider>(context, listen: false).currentScreenId = -1;
            Provider.of<EditProvider>(context, listen: false).selectedLayerId = -1;
            Navigator.popUntil(context, ModalRoute.withName('Login'));
            // Navigator.of(context).pushReplacementNamed('Login');
            // Navigator.pop(context);
            // Navigator.pop(context);
            
            // await Exit.pop(animated:true);//暂时关闭app
          },
        ),
      ),
    );
  }

  //用户登出按钮
  Widget _logoutBtn(context) {
    return Container(
      width: Utils.setWidth(142),
      height: Utils.setWidth(52),
      // color: Colors.blueAccent,
      child: Column(
        children: <Widget>[
          Container(
            width: Utils.setWidth(24),
            // height: Utils.setHeight(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: Utils.setWidth(11),
                  color: ColorMap.btnLoginout_bkg_color,//ColorMap.header_background, //三角形边框颜色
                ),
                left: BorderSide(
                  width: Utils.setWidth(12),
                  color: Colors.transparent, //三角形边框颜色
                ),
                right: BorderSide(
                  width: Utils.setWidth(12),
                  color: Colors.transparent, //三角形边框颜色
                ),
              ),
            ),
          ),
          Container(
            width: Utils.setWidth(142),
            height: Utils.setWidth(38),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorMap.btnLoginout_bkg_color,//ColorMap.header_background,
            ),
            child: Text(
              "退出",
              style: TextStyle(
                color: ColorMap.white,//ColorMap.button_font_color,
                fontSize: Utils.setFontSize(14)),
            ),
          ),
        ],
      ),
    );
  }
}
