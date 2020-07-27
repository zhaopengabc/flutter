/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-12 19:53:04
 */ 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/util_index.dart';

class InputTemplate extends StatefulWidget {
  final double width;
  final double height;
  InputTemplate({this.width, this.height});
  @override
  _InputTemplateState createState() => _InputTemplateState();
}

class _InputTemplateState extends State<InputTemplate> {
  @override
  Widget build(BuildContext context) {
  // print('手势宽${widget.width}, 手势高${widget.height}');
    return Container(
      alignment: Alignment.centerLeft,
      // color: Colors.yellow,
      child: SizedBox(
        width: widget.width,//Utils.setWidth(206),
        height: widget.height,
        child: Column(
          children: <Widget>[
            Container(
              width: widget.width,//Utils.setWidth(206), ////图片的宽
              height: widget.height,//Utils.setHeight(116.0), //图片高度
              alignment: Alignment.center, //对齐方式
              // child: Image.asset(
              //   'assets/images/input/input1.png',
              //   width: widget.width - 5,//Utils.setWidth(206), ////图片的宽
              //   height: widget.height - 5,//Utils.setHeight(116.0), //图片高度
              //   alignment: Alignment.center, //对齐方式
              //   repeat: ImageRepeat.noRepeat, //重复方式
              //   fit: BoxFit.fill, //fit缩放模式
              // ),
              decoration: BoxDecoration(
                color: ColorMap.layer_bg_template,
                border: Border.all(
                  width: Utils.setWidth(1.0),
                  color: ColorMap.orange_selected, //边框颜色
                  style: BorderStyle.solid
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
