/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-07-07 16:42:19
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-08 18:07:57
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/util_index.dart';
import 'package:provider/provider.dart';

class CopyToolbar extends StatefulWidget {
  final clipBoardContent;
  final Function paste;
  CopyToolbar({this.clipBoardContent, this.paste});
  @override
  _CopyToolbarState createState() => _CopyToolbarState();
}

class _CopyToolbarState extends State<CopyToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        // height: Utils.setHeight(50) + Utils.setWidth(27),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(8.0),
                ),
              ),
              child: Row(
                children: <Widget>[
                  // GestureDetector(
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(
                  //         horizontal:
                  //             Utils.setWidth(10),
                  //         vertical:
                  //             Utils.setWidth(2)),
                  //     child: Text(
                  //       '复制',
                  //       style: TextStyle(
                  //           color: ColorMap.version_font),
                  //     ),
                  //   ),
                  //   onTapDown: (e) {},
                  // ),

                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Utils.setWidth(10),
                          vertical: Utils.setWidth(2)),
                      child: Text(
                        '粘贴',
                        style: TextStyle(color: ColorMap.version_font),
                      ),
                    ),
                    onTapDown: (e) async {
                      ClipboardData data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (widget.paste != null) {
                        widget.paste(data);
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
                width: Utils.setWidth(12),
                height: Utils.setWidth(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        width: Utils.setWidth(6),
                        color: Colors.black, //三角形边框颜色
                      ),
                      left: BorderSide(
                        width: Utils.setWidth(6),
                        color: Colors.transparent, //三角形边框颜色
                      ),
                      right: BorderSide(
                        width: Utils.setWidth(6),
                        color: Colors.transparent, //三角形边框颜色
                      )),
                )),
          ],
        ));
  }
}
