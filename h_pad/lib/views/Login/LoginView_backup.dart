
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/index.dart';
import 'package:h_pad/states/main/UserProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute>  with WidgetsBindingObserver {
  // GlobalKey _globalKey = new GlobalKey(); //用来标记控件
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  // 输入框焦点 问题
  FocusNode userFocusNode = new FocusNode();
  FocusNode pwdFocusNode = new FocusNode();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = false;
  bool _expand = false; //是否展示历史账号
  List<User> _users = new List(); //历史账号
  bool pwdShow = false; //密码是否显示明文
  final _scrollController = ScrollController();
  FocusScopeNode _focusScopeNode;
  bool _loginBtnDisabled = false;
  bool isLeave = false;

  @override
  void initState() {
    print('进入登录页状态初始化');
    WidgetsBinding.instance.addObserver(this);
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text != null && _unameController.text != '') {
      print('_unameController.text${_unameController.text}');
      _nameAutoFocus = true;
    }
    //获取 历史登录客户
    _users = UserNames().getUserNames();
    super.initState();
  }

  /// State对象依赖发生变化调用；系统语言、主题修改，系统也会通知调用
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(ModalRoute.of(context)?.settings?.name == 'Init'){
      isLeave = false;
    }else {
      isLeave = true;
      Future.delayed(Duration(milliseconds: 0)).then((e) {
        _pwdController.text = "";
      });
    }
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  /// 热重载会被调用，在release下永远不会被调用
  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('reassemble');
  }

  /// 新旧Widget的key、runtimeType不变时调用。也就是Widget.canUpdate=>true
  @override
  void didUpdateWidget(LoginRoute oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  /// State在树种移除调用
  @override
  void deactivate() {
    // EasyLoading.dismiss();
    if (ModalRoute.of(context).isCurrent) {
      isLeave = false;
       
    }else {
      isLeave = true;
      Future.delayed(Duration(milliseconds: 0)).then((e) {
        _pwdController.text = "";
      });
    }
    super.deactivate();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    userFocusNode.dispose();
    pwdFocusNode.dispose();
    print('dispose-login');
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
    // var gm = Translations.of(context);
    return GestureDetector(
      child: Scaffold(
        backgroundColor: ColorMap.app_main,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(backgroundColor: ColorMap.app_main),
        body: new SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: Utils.setWidth(500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, Utils.setHeight(70), 0, Utils.setHeight(4)),
                        child: Image(
                          image: AssetImage('assets/images/common/logo.png'),
                          width: Utils.setWidth(112),
                          height: Utils.setHeight(78),
                        ),
                      ),
                      Container(
                        width: Utils.setWidth(320),
                        child:
                        // SingleChildScrollView(
                        //   child:
                          Form(
                            key: _formKey,
                            autovalidate: true,
                            child: Column(
                              children: <Widget>[
                                _userText(),
                                _passedsText(),
                                _button(),
                                //  Loading(indicator: BallPulseIndicator(), size: 100.0, color: Colors.pink),
                              ],
                            ),
                          ),
                        ),
                      // )
                    ],
                  ),
                ),
              ),
              Offstage(
                child: _buildListView(),
                offstage: !_expand,
              ),
            ],
          )
        ),
        bottomNavigationBar: Container(
          height: Utils.setHeight(60),
          alignment: Alignment.center,
          child: Text('软件版本 V1.0.0.0.S2.T2',
            style: TextStyle(
              color: ColorMap.version_font,
              fontSize: Utils.setFontSize(18),
              decoration: TextDecoration.none,
              fontFamily: 'PingFangSCRegular',
            )
          ),
        )
      ),
      onTap: () {
        setState(() {
          _expand = false;
        });
      },
    );
  }

  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        return Container(
          decoration: BoxDecoration(
            color: ColorMap.layer_bg,
            border: Border(
              top: BorderSide(width: Utils.setWidth(2), color: ColorMap.border_color_split),
            ),
          ),
          child: ListView(
            // itemExtent: Utils.setHeight(32),
            padding: EdgeInsets.all(0),
            children: children,
          ),
          width: Utils.setWidth(320),
          height: Utils.setHeight(177),
          margin: EdgeInsets.fromLTRB(0, Utils.setHeight(160), 0, 0),
        );
      }
    }
    return null;
  }

  ///构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = new List();
    for (int i = 0; i < _users.length; i++) {
      //增加账号记录
      list.add(_buildItem(_users[i]));
      //增加分割线
      list.add(Divider(
        height: Utils.setHeight(1),
        color: ColorMap.text_normal,
      ));
    }
    if (list.length > 0) {
      list.removeLast(); //删掉最后一个分割线
    }
    return list;
  }

  ///构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        height: Utils.setHeight(58),
        width: Utils.setWidth(320),
        decoration: BoxDecoration(
          color: user.login == _unameController.text ? Color(0xff232323) : Color(0xff141414),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: Utils.setWidth(19)),
                child: Text(
                  user.login,
                  style: TextStyle(
                    color: ColorMap.text_normal,
                    fontSize: Utils.setFontSize(18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: Utils.setHeight(36)),
                child: Image(
                  image: AssetImage('assets/images/common/icon_clear.png'),
                  width: Utils.setWidth(18),
                  height: Utils.setHeight(18),
                ),
              ),
              onTap: () {
                setState(() {
                  UserNames().delUser(_users, user);
                  _users.remove(user);
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if (_users.length <= 0) {
                    _expand = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _unameController.text = user.login;
          _pwdController.text = '';
          userFocusNode.unfocus();
          pwdFocusNode.requestFocus();
          _expand = false;
        });
      },
    );
  }

  Widget _userText() {
    return TextFormField(
      autofocus: !_nameAutoFocus,
      focusNode: userFocusNode,
      controller: _unameController,
      keyboardType: TextInputType.text,
      enableInteractiveSelection: false,
      style: TextStyle(
        color: ColorMap.text_normal,
        fontSize: Utils.setFontSize(18),
      ),
      decoration: InputDecoration(
        hintText: "请输入账户",//Translations.of(context).text('login.AccountPlaceholder'),
        hintStyle: TextStyle(
          color: ColorMap.text_normal,
          fontSize: Utils.setFontSize(18),
        ),
        // prefixIcon: Icon(
        //   Icons.person,
        //   color: ColorMap.text_normal,
        // ),
        prefixIcon: Image(
          image: AssetImage('assets/images/common/icon_user_normal.png'),
          height: Utils.setHeight(24),
          width: Utils.setWidth(24),
        ),
        // 未获得焦点下划线设为灰色
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMap.border_color_split),
        ),
        suffixIcon: Container(
          width: Utils.setWidth(70),
          height: Utils.setHeight(18),
          margin: EdgeInsets.only(right: Utils.setHeight(20)),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: Utils.setWidth(18),
              height: Utils.setHeight(18),
              margin: _users.length > 1 ? EdgeInsets.only(right: Utils.setHeight(30)) : EdgeInsets.only(right: Utils.setHeight(10)),
              child: new IconButton(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0.0),
                icon: Icon(Icons.cancel, color: ColorMap.del_font),
                iconSize: Utils.setFontSize(20),
                onPressed: () {
                  _unameController.text = "";
                },
              ),
            ),
            _users.length > 1
            ? GestureDetector(
                onTap: () {
                  if (_users.length > 1) {
                    //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                    setState(() {
                      _expand = !_expand;
                    });
                  }
                  print('_expand $_expand');
                },
                child: _expand
                  ? Image(
                      image: AssetImage('assets/images/common/icon_up_arrow_normal.png'),
                      width: Utils.setWidth(20),
                      height: Utils.setHeight(11),
                    )
                  : Image(
                      image: AssetImage('assets/images/common/icon_down_arrow_normal.png'),
                      width: Utils.setWidth(20),
                      height: Utils.setHeight(11),
                    ),
              )
            : Text(""),
          ],
        )
        ),

        //获得焦点下划线设为灰色
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorMap.border_color_split,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: Utils.setFontSize(10),
        ),
      ),
      maxLength: 20,
      maxLengthEnforced: true,
      // 校验用户名（不能为空）
      validator: (v) { // v.trim().isNotEmpty ||
        if (new RegExp(RegExps.pass_Normal).hasMatch(v)) {
          return null;
        } else {
          return '账号格式输入错误';
        }
      },
      onEditingComplete: () {
        print('获取焦点---${userFocusNode.hasFocus}');
        userFocusNode.unfocus();
        pwdFocusNode.requestFocus();
      }
    );
  }

  Widget _passedsText() {
    return TextFormField(
      controller: _pwdController,
      autofocus: _nameAutoFocus,
      focusNode: pwdFocusNode,
      enableInteractiveSelection: false, //禁止复制粘贴
      style: TextStyle(color: ColorMap.text_normal, fontSize: Utils.setFontSize(18)),
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock, color: ColorMap.text_normal,),
        prefixIcon: Image(
          image: AssetImage('assets/images/common/icon_password_normal.png'),
          height: Utils.setHeight(24),
          width: Utils.setWidth(24),
        ),
        hintText: '请输入密码',
        hintStyle: TextStyle(color: ColorMap.text_normal, fontSize: Utils.setFontSize(18)),
        errorStyle: TextStyle(
          fontSize: Utils.setFontSize(10),
        ),
        // 未获得焦点下划线设为灰色
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMap.border_color_split),
        ),
        //获得焦点下划线设为灰色
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorMap.border_color_split),
        ),
        suffixIcon: Container(
          width: Utils.setWidth(18),
          height: Utils.setHeight(18),
          margin: EdgeInsets.only(right: Utils.setHeight(20)),
          child: new IconButton(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0.0),
            icon: Icon(Icons.cancel, color: ColorMap.del_font),
            iconSize: Utils.setFontSize(20),
            onPressed: () {
              _pwdController.text = "";
            },
          ),
        ),
      ),
      obscureText: !pwdShow,
      //校验密码（不能为空）
      maxLength: 20,
      maxLengthEnforced: true,
      validator: (v) {
        // print('校验');
        if (new RegExp(RegExps.pass_Normal).hasMatch(v) || (isLeave && v=='')) {
          return null;
        } else {
          return '密码格式输入错误';
        }
        // return v.trim().isNotEmpty ? null : '密码不能为空';
      },
      onEditingComplete: () {
        pwdFocusNode.unfocus();
      },
    );
  }

  Widget _button() {
    return Padding(
      // padding: EdgeInsets.only(top: Utils.setHeight(25)),
      padding: EdgeInsets.fromLTRB( Utils.setHeight(15), Utils.setHeight(25), Utils.setHeight(25), Utils.setHeight(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          height: Utils.setHeight(55),
          width: Utils.setWidth(300),
        ),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,//_loginBtnDisabled ? ColorMap.button_disabled_color : Theme.of(context).primaryColor,
          onPressed: _onLogin,
          textColor: Colors.white,
          child: Text("登录"),//Translations.of(context).text('login.Login')
        ),
      ),
    );
  }

  // 登录
  void _onLogin() async {
    if (_loginBtnDisabled) {
      return;
    }
    // setState(() {
      _loginBtnDisabled = true;
    // });
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      // showLoadingDialog(context);
      // LoadingDialog loadingDialog = new LoadingDialog(context);
      Login login;
      User user;
      FocusScope.of(context).requestFocus(FocusNode());
      try{
        EasyLoading.show(status: 'loading...');
        EasyLoading.instance..maskType = EasyLoadingMaskType.black;

        HttpUtil(context).getInstance().request(Api.LOGIN, data: {
          'deviceId': 0,
          'username': _unameController.text,
          'password': _pwdController.text,
        }).then((res) {
          // Navigator.of(context).pop(); //关闭遮罩层
          // print('loadingDialog.state${LoadingDialog.state}');
          // loadingDialog.dispose();
          // print('loadingDialog.state${LoadingDialog.state}');
          if (res.code == 0) {
            login = Login.fromJson(res.data);
            //更新profile中的token信息
            Global.setToken = login.token;
            user = User.fromJson({
              'login': _unameController.text,
              'password': _pwdController.text,
              'isAdmin': login.isAdmin,
              'userId': login.userId,
            });
            Provider.of<UserModel>(context, listen: false).user = user;
            Provider.of<UserProvider>(context, listen: false).currentUser = login;
            //存储 登录 历史
            UserNames().addNoRepeat(_users, user);
            Navigator.of(context).pushNamed('Edit');
          } else {
            EasyLoading.dismiss();
          }
        }).catchError((err) {
          // Navigator.of(context).pop(); //关闭遮罩层
          // print('loadingDialog.state${LoadingDialog.state}');
          EasyLoading.dismiss();
          print('err: $err');
        }).whenComplete(() {
          // EasyLoading.dismiss();
          // print('赋值');
          // setState(() {
            _loginBtnDisabled = false;
          // });
        });
      }catch(e){
        EasyLoading.dismiss();
      }
    } else {
      print('登录内容校验失败');
      // setState(() {
        _loginBtnDisabled = false;
      // });
    }
  }
  // void mockDevice() async {
  //   final loginUsers = await rootBundle.loadString('lib/mock/loginUsers.json');
  //   // print('listJson------------:$loginUsers');
  //   List<dynamic> list = json.decode(loginUsers);
  //   setState(() {
  //     _users = list.map((value) => new User.fromJson(value)).toList();
  //   });
  //   print('users: ${_users.length}');
  // }
}
