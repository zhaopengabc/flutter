/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-09 17:40:28
 */ 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:provider/provider.dart';

class Popup extends StatelessWidget {
  final Widget child;
  final Function onClick; //点击child事件
  final double left; //距离左边位置
  final double top; //距离上面位置
  final double right; //距离上面位置
  final double bottom; //距离上面位置

  Popup({
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
                  onTap: () {
                    //点击子child
                    if (onClick != null) {
                      // Navigator.of(context).pop();
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
        onTap: () {
          //点击空白处
          Navigator.of(context).pop();
          Provider.of<EditProvider>(context, listen: false).isBrightnessBtnSel = !Provider.of<EditProvider>(context, listen: false).isBrightnessBtnSel;
        },
      ),
    );
  }
}

enum ClickType{
  tap,
  tapDown
}
