/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-20 10:37:48
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-20 16:02:05
 */ 
/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-05-20 10:24:41
 */ 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutPopup extends StatelessWidget {
  final Widget child;
  final Function onClick; //点击child事件
  final double left; //距离左边位置
  final double top; //距离上面位置
  final double right; //距离上面位置
  final double bottom; //距离上面位置

  LogoutPopup({
    @required this.child,
    this.onClick,
    this.left,
    this.top,
    this.right,
    this.bottom
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              child: GestureDetector(
                  child: child,
                  onTapDown: (e) {
                    //点击子child
                    if (onClick != null) {
                      Navigator.of(context).pop();
                      onClick();
                    }
                  }),
              left: left,
              top: top,
              right: right,
              bottom: bottom,
            ),
          ],
        ),
        onTapDown: (e) {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

enum ClickType{
  tap,
  tapDown
}
