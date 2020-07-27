/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-07-01 18:31:36
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-06 18:39:32
 */
import 'package:flutter/material.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/utils/util_index.dart';
import 'package:h_pad/states/main/AuthProvider.dart';
import 'package:provider/provider.dart';

class AuthorizationTipView extends StatelessWidget {
  static const tipContent = '目前设备未授权，试用权限为7天，请及时联系经销商。';
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.transparent, //ColorMap.modal_mask,
            child: Container(
                decoration: BoxDecoration(
                  color: ColorMap.bkg_auth,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(14.0),
                  ),
                ),
                height: Utils.setWidth(232),
                width: Utils.setWidth(432),
                child: Stack(
                  // alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(Utils.setWidth(35),
                          Utils.setWidth(23), Utils.setWidth(35), 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text('授权提示',
                                style: TextStyle(
                                    fontSize: Utils.setFontSize(18),
                                    fontWeight: FontWeight.bold,
                                    color: ColorMap.txt_font_color)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Utils.setWidth(35)),
                            child: Text('$tipContent',
                                style: TextStyle(
                                    fontSize: Utils.setFontSize(18),
                                    color: ColorMap.txt_font_color)),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: Utils.setWidth(182),
                        left: 0,
                        child: Container(
                          width: Utils.setWidth(432),
                          // height: Utils.setWidth(39),
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
                                      )),
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        Utils.setWidth(10),
                                        0,
                                        Utils.setWidth(10)),
                                    autofocus: false,
                                    child: Text('关闭',
                                        style: TextStyle(
                                            fontSize: Utils.setFontSize(18),
                                            color: ColorMap.btn_auth)),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Provider.of<AuthProvider>(context, listen: false).tipCode = -1;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ))));
    ;
  }
}
