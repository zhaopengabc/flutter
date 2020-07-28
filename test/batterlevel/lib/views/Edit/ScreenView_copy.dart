// 屏幕部分
import 'package:flutter/material.dart';
import 'package:h_pad/common/CustomerSizeChangedLayoutNotifier.dart';
import 'package:h_pad/states/edit/RenderBoxProvider.dart';
import 'package:h_pad/utils/utils.dart';
import 'package:flutter/rendering.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/constants/layout.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/common/global.dart';

class ScreenView extends StatefulWidget {
  @override
  _ScreenViewState createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView> {
  // double screenWidth = (LayoutConstant.UILayoutWidth - LayoutConstant.PresetListWidth - LayoutConstant.SplitScrernWidth - 30*2).toDouble();
  // double screenHeight = (LayoutConstant.UILayoutHeight - LayoutConstant.HeadHeight - LayoutConstant.InputListHeight - LayoutConstant.ActionBtnHeight - 30*2).toDouble();
  double screenWidthBlank = (LayoutConstant.UILayoutWidth -
          LayoutConstant.PresetListWidth -
          LayoutConstant.SplitScrernWidth -
          30 * 2)
      .toDouble(); // 空白区域宽
  double screenHeightBlank = (LayoutConstant.UILayoutHeight -
          LayoutConstant.HeadHeight -
          LayoutConstant.InputListHeight -
          LayoutConstant.ActionBtnHeight -
          30 * 2)
      .toDouble(); // 空白区域高
  double screenWidth = 0;
  double screenHeight = 0;
  int screenRealW = 0;
  int screenRealH = 0;
  int screenRealX = 0;
  int screenRealY = 0;
  double scale = 1;
  List<Widget> layerList = [];
  List<Widget> outputModeList = [];
  List layerListData;
  List screenInterfaces;
  var bkgEnable = 0;
  var bkgUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    if (editProvider.currentScreen != null &&
        editProvider.currentScreen.outputMode != null &&
        editProvider.currentScreen.outputMode.size != null) {
      screenRealW = editProvider.currentScreen.outputMode.size.width;
      screenRealH = editProvider.currentScreen.outputMode.size.height;
      screenRealX = editProvider.currentScreen.outputMode.size.x;
      screenRealY = editProvider.currentScreen.outputMode.size.y;

      layerListData = editProvider.currentScreen.screenLayers;
      // print('================+++++++++${layerList.length}');
      screenInterfaces = editProvider.currentScreen.outputMode.screenInterfaces;
      bkgEnable = editProvider.currentScreen.bkg.enable;
      if (bkgEnable == 1) {
        bkgUrl = editProvider.currentScreen.bkg.imgUrl;
      }
    }

    setScreenSize();
    outputModes();
    if (bkgEnable == 1) {
      setBkg();
    }
    createLayerBatch();

    return NotificationListener<LayoutChangedNotification>(
      onNotification: (notification) {
        /// 收到布局结束通知,打印尺寸
        // _printSize();
        /// flutter1.7之后需要返回值,之前是不需要的.
        _printSize();
        return null;
      },
      child: CustomerSizeChangedLayoutNotifier(
        child: Container(
          // decoration: new BoxDecoration(
          //   border: Border.all(width:Utils.setWidth(1), color: ColorMap.screen_border_color)
          // ),
          // margin: EdgeInsets.only(top: Utils.setHeight(60)),
          width: Utils.setWidth(screenWidth),
          height: Utils.setHeight(screenHeight),
          child: 
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //         flex: 1,
                  // child:
                   Consumer<EditProvider>(
                      builder: (BuildContext context, data, Widget child) {
                    return Container(
                      color: ColorMap.screen_color,
                      child: Stack(children: outputModeList),
                    );
                  }),
          //         )
          //   ],
          // ),
        ),
      ),
    );
  }

  //打印渲染后的组件尺寸
  _printSize() {
    if (!mounted) return;
    Size size = context?.findRenderObject()?.paintBounds?.size;
    // print('屏幕size=========:$size');
    Provider.of<RenderBoxProvider>(context, listen: false).screenRenderBoxSize = size;

    Future.delayed(Duration(milliseconds: 200)).then((e) {
      RenderBox screenRegionBox = context?.findRenderObject();
      Offset screenRegionOffset = screenRegionBox.localToGlobal(Offset.zero);
      // print('屏幕Offset:$screenRegionOffset');
      Provider.of<RenderBoxProvider>(context, listen: false)
      .screenRenderBoxOffset = screenRegionOffset;
    });
  }

  // 设置屏幕尺寸
  setScreenSize() {
    // print('真实的宽度：${screenRealW}');
    // print('真实的高度：${screenRealH}');
    if (screenRealW != 0 && screenRealH != 0) {
      if (screenRealW > screenRealH) {
        setState(() {
          screenWidth = (LayoutConstant.UILayoutWidth -
                  LayoutConstant.PresetListWidth -
                  LayoutConstant.SplitScrernWidth -
                  30 * 2)
              .toDouble();
          screenHeight = screenRealH / screenRealW * screenWidth;
          if (screenHeight > screenHeightBlank) {
            // 处理高超出空白区域的情况
            screenHeight = screenHeightBlank;
            screenWidth = screenRealW / screenRealH * screenHeight;
          }
        });
      } else {
        setState(() {
          screenHeight = (LayoutConstant.UILayoutHeight -
                  LayoutConstant.HeadHeight -
                  LayoutConstant.InputListHeight -
                  LayoutConstant.ActionBtnHeight -
                  30 * 2)
              .toDouble();
          screenWidth = screenRealW / screenRealH * screenHeight;
          if (screenWidth > screenWidthBlank) {
            screenWidth = screenWidthBlank;
            screenHeight = screenRealH / screenRealW * screenWidth;
          }
        });
      }
      scale = screenWidth / screenRealW;
      // print('计算后的屏幕比例： $scale');
      // print('计算后的屏幕比例： $screenWidth----$screenRealW');
    }

    // print('计算后的屏幕宽高： ${screenWidth} ${screenHeight}');
    //  print('计算后的屏幕宽高： ${Utils.setWidth(screenWidth)} ${Utils.setHeight(screenHeight)}');
  }

  /*
  * @description : 开窗
  * @param {int}: x y w h -图层信息
  */
  createLayer(x, y, w, h) {
    // print('窗口的size: ${x} ${y} ${w} ${h}');
    setState(() {
      layerList.add(Stack(
        children: <Widget>[
          Positioned(
            left: Utils.setWidth((x - screenRealX) * scale),
            top: Utils.setHeight((y - screenRealY) * scale),
            child: Container(
              width: Utils.setWidth(w * scale),
              height: Utils.setHeight(h * scale),
              child: Image.asset('assets/images/input/input1.png',
                  fit: BoxFit.fill),
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1.0, color: ColorMap.layer_border_color),
              ),
            ),
          )
        ],
      ));
    });
    // print('窗口的size: ${(x - screenRealX)*scale} ${(y - screenRealY)*scale} ${w*scale} ${h*scale} 比例： ${scale}');
  }

  // 批量开窗
  createLayerBatch() {
    setState(() {
      layerList = [];
      if (layerListData != null) {
        layerListData = sortLayerByZorder(layerListData);
        layerListData.forEach((layer) {
          createLayer(layer.window.x, layer.window.y, layer.window.width,
              layer.window.height);
        });
      }
    });
    outputModeList.addAll(layerList);
    // print('layerList===       ${layerList.length}');
  }

  /*
   * @description : 绘制输出拼接
   */
  outputModes() {
    outputModeList = [];
    if (screenInterfaces != null) {
      screenInterfaces.forEach((screenInterface) {
        createOutputMode(screenInterface.x, screenInterface.y,
            screenInterface.width, screenInterface.height);
      });
    }
  }

  /*
   * @description : 绘制单个输出拼接
   * @param {List}: outputInterface 输出接口数据
   */
  createOutputMode(x, y, w, h) {
    setState(() {
      outputModeList.add(Stack(
        children: <Widget>[
          Positioned(
            left: Utils.setWidth((x - screenRealX) / screenRealW * screenWidth),
            top:
                Utils.setHeight((y - screenRealY) / screenRealH * screenHeight),
            child: Container(
              width: Utils.setWidth(w / screenRealW * screenWidth),
              height: Utils.setHeight(h / screenRealH * screenHeight),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0, color: ColorMap.screen_border_color)),
            ),
          )
        ],
      ));
    });
  }

  // 根据z序将图层列表排序
  sortLayerByZorder(layerListData) {
    for (var i = 1; i < layerListData.length; i++) {
      if (layerListData[i].general.zorder <
          layerListData[i - 1].general.zorder) {
        var temp = layerListData[i];
        var j = i - 1;
        layerListData[i] = layerListData[j];
        while (
            j >= 0 && temp.general.zorder < layerListData[j].general.zorder) {
          layerListData[j + 1] = layerListData[j];
          j--;
        }
        layerListData[j + 1] = temp;
      }
    }
    return layerListData;
  }

  setBkg() {
    setState(() {
      outputModeList.add(Stack(
        children: <Widget>[
          Positioned(
              left: Utils.setWidth(0),
              top: Utils.setHeight(0),
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: Utils.setWidth(screenWidth),
                  height: Utils.setHeight(screenHeight),
                  child: Image.network('${Global.getBaseUrl}${bkgUrl}',
                      fit: BoxFit.fill),
                ),
              ))
        ],
      ));
    });
  }
}
