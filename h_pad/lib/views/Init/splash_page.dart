/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-08 19:26:55
 */ 
import 'package:flutter/material.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:h_pad/views/Init/InitView.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    //Navigator.pushNamed(context, 'DeviceLists');
    super.initState();
    startHome();
  }

  //显示2秒后跳转到HomeTabPage
  startHome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InitRouter()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return 
      ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  AssetImage('assets/images/common/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/images/common/logo.png'),
                  width: Utils.setWidth(112),
                  height: Utils.setHeight(78),
                ),
                // color: ColorMap.app_main,
              ),
              Positioned(
                bottom: Utils.setHeight(22),
                child: Text(
                  'Copyright © 2020 NovaStar Tech Co., Ltd. All rights reserved.',
                  style: TextStyle(
                    color: ColorMap.text_normal,
                    fontSize: Utils.setFontSize(16),
                  ),
                ),
              )
            ],
          ),
        ),
        
      );
    });
  }
}
