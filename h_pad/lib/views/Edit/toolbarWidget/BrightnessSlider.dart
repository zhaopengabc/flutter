import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/style/index.dart';

class BrightnessSlider extends StatefulWidget {
  final Function onSliderChanged;
  final int initValue;
  BrightnessSlider({this.initValue, this.onSliderChanged});
  @override
  _BrightnessSlider createState() => _BrightnessSlider();
}

class _BrightnessSlider extends State<BrightnessSlider>
    with WidgetsBindingObserver {
  int progressValue = 0;
  @override
  void initState() {
    progressValue = widget.initValue;
    super.initState();
  }

  @override
  didUpdateWidget(oldWidget) {
    _handleValueChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _handleValueChanged() {
    setState(() {
      progressValue = widget.initValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ColorMap.header_background,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(Utils.setWidth(14), 0, Utils.setWidth(14), 0),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/edit/icon_brightness_min_normal.png',
            width: Utils.setWidth(24.0), ////图片的宽
            height: Utils.setWidth(24.0), //图片高度
            alignment: Alignment.center, //对齐方式
            repeat: ImageRepeat.noRepeat, //重复方式
            fit: BoxFit.fill, //fit缩放模式
          ),
          Container(
              // color: Colors.red,//ColorMap.header_background,
              width: Utils.setWidth(274), //Utils.setWidth(274),
              padding: EdgeInsets.fromLTRB(
                  Utils.setWidth(8), 0, Utils.setWidth(10), 0),
              child:
                  // new Slider(
                  //   value: progressValue.toDouble(), //实际进度的位置
                  //   inactiveColor: ColorMap.slider_inactiveColor, //进度中不活动部分的颜色
                  //   label: '${progressValue.floor()}%',
                  //   min: 0.0,
                  //   max: 100.0,
                  //   divisions: 1000,
                  //   activeColor: ColorMap.slider_activeColor, //进度中活动部分的颜色
                  //   onChangeStart: (value) {
                  //     // print('888888888888onChangeStart888888888888888');
                  //   },
                  //   onChangeEnd: (value) {
                  //     // print('9999999999999999onChangeEnd9999999999999');
                  //     widget.onSliderChanged(value.floor());
                  //   },
                  //   onChanged: (value) {
                  //     setState(() {
                  //       progressValue = value.floor();
                  //     });
                  //   },
                  // ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    //已拖动的颜色
                    activeTrackColor: ColorMap.slider_activeColor,
                    //未拖动的颜色
                    inactiveTrackColor: ColorMap.slider_inactiveColor,
                    //提示进度的气泡的背景色
                    valueIndicatorColor: ColorMap.slider_valueIndicator_color,
                    //提示进度的气泡文本的颜色
                    valueIndicatorTextStyle: TextStyle(
                      color: ColorMap.slider_activeColor,
                      fontSize: Utils.setFontSize(14),
                      fontWeight: FontWeight.bold,
                    ),
                    //滑块中心的颜色
                    thumbColor: ColorMap.slider_valueIndicator_color, //Colors.blueAccent,
                    //滑块边缘的颜色
                    overlayColor: ColorMap.slider_valueIndicator_color,
                    //divisions对进度线分割后，断续线中间间隔的颜色
                    inactiveTickMarkColor: ColorMap.slider_valueIndicator_color,
                    thumbShape: RoundSliderThumbShape(
                      //可继承SliderComponentShape自定义形状
                      disabledThumbRadius: Utils.setWidth(12), //禁用是滑块大小
                      enabledThumbRadius: Utils.setWidth(12), //滑块大小
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      //可继承SliderComponentShape自定义形状
                      overlayRadius: Utils.setWidth(12), //滑块外圈大小
                    ),
                    showValueIndicator:
                        ShowValueIndicator.onlyForDiscrete, //气泡显示的形式
                ),
                child: Slider(
                  value: progressValue.toDouble(),
                  label: '$progressValue%',
                  min: 0.0,
                  max: 100.0,
                  divisions: 1000,
                  onChanged: (val) {
                    setState(() {
                      progressValue = val.floor(); //转化成double
                    });
                  },
                  onChangeEnd: (value) {
                    widget.onSliderChanged(value.floor());
                  },
                ),
              )),
          Image.asset(
            'assets/images/edit/icon_brightness_max_normal.png',
            width: Utils.setWidth(28), ////图片的宽
            height: Utils.setWidth(28.0), //图片高度
            alignment: Alignment.center, //对齐方式
            repeat: ImageRepeat.noRepeat, //重复方式
            fit: BoxFit.fill, //fit缩放模式
          ),
        ],
      ),
    );
  }
}
