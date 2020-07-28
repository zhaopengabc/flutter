import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:h_pad/style/index.dart';
import 'package:h_pad/theme/themColor.dart';
import 'package:h_pad/utils/utils.dart';

class Decorations extends StatefulBuilder {
  static Decoration item = BoxDecoration(
      color: ColorMap.border_color_split,
      border: Border(bottom: BorderSide(width: Utils.setWidth(0.66), color: ColorMap.divider)));

  /*表单分割线*/
  static Decoration formBorder = BoxDecoration(
      color: ColorMap.component_bg,
      border: new Border(bottom: BorderSide(width: Dimens.border_table, color: ColorMap.border_color_split)));

  /*表单分割间距*/
  static Decoration formBorderBack = BoxDecoration(
      color: ColorMap.body_bg,
      border: new Border(bottom: BorderSide(width: Dimens.border_table, color: ColorMap.border_color_split)));

  /*表格分割线*/
  static Decoration tableBorder = BoxDecoration(color: ColorMap.component_bg
//      border: new Border.all(width: Dimens.border_table, color: YColors.themeColor[Global.themeIndex]["pageSpaceColor"])
      );

  /*模态框分割间距*/
  static Decoration modelBorderBack = BoxDecoration(
      color: ColorMap.body_bg,
      border: new Border(bottom: BorderSide(width: Dimens.border_table, color: ColorMap.border_color_split)));
  /*Card分割线*/
  static Decoration cardBorder = BoxDecoration(
      color: ColorMap.component_bg,
      borderRadius: BorderRadius.all(Radius.circular(Utils.setWidth(8))),
      border: new Border.all(width: Dimens.border_table, color: ColorMap.border_color_split),
      boxShadow: <BoxShadow>[
        BoxShadow(color: ColorMap.shadow_color, offset: Offset(Utils.setWidth(1), Utils.setWidth(6)))
      ]);
  /*Box分割线*/
  static Decoration boxBorder = BoxDecoration(
    color: ColorMap.component_bg,
    border: new Border.all(width: Dimens.border_table, color: ColorMap.border_color_split),
  );
  /*头部分割线*/
  static Decoration headerBorder = BoxDecoration(
      color: ColorMap.white,
      border: new Border(bottom: BorderSide(width: Dimens.border_table, color: ColorMap.border_color_split)));

  /*模态面板分割线*/
  static Decoration modelBorder = BoxDecoration(
      color: YColors.themeColor[0]["pageColor"],
      border: new Border.all(width: Dimens.border_table, color: ColorMap.border_color_split));

  /*冷色Active边框*/
  static Decoration colorTemperateBorder_0 = BoxDecoration(
    color: ColorMap.colorTemperate_bg_0,
    border: new Border.all(width: Dimens.border_colorTemperate, color: ColorMap.active_color),
  );

  /*正白Active边框*/
  static Decoration colorTemperateBorder_1 = BoxDecoration(
      color: ColorMap.colorTemperate_bg_1,
      border: new Border.all(width: Dimens.border_colorTemperate, color: ColorMap.active_color));

  /*中性白Active边框*/
  static Decoration colorTemperateBorder_2 = BoxDecoration(
      color: ColorMap.colorTemperate_bg_2,
      border: new Border.all(width: Dimens.border_colorTemperate, color: ColorMap.active_color));
}

class Dividers {
  static var divider_view = Divider(height: Dimens.gap_view, color: ColorMap.body_bg); //模态视图间距
}

class Paddings {
  static var table = EdgeInsets.only(
      left: Utils.setWidth(32), top: Utils.setWidth(24), right: Utils.setWidth(32), bottom: Utils.setWidth(24));
  static var form = EdgeInsets.only(
      left: Utils.setWidth(32), top: Utils.setWidth(24), right: Utils.setWidth(32), bottom: Utils.setWidth(24));
  static var view = EdgeInsets.only(left: Utils.setWidth(32), top: 0, right: Utils.setWidth(32), bottom: 0);
  static var item = EdgeInsets.only(
      left: Utils.setWidth(20), top: Utils.setWidth(30), right: Utils.setWidth(20), bottom: Utils.setWidth(30));
}

/*尺寸定义*/
class Dimens {
  /*字体大小*/
  static double normal = Utils.setFontSize(30); //正常字体
  static double subTitle = Utils.setFontSize(24); //
  static double tip = Utils.setFontSize(28);
  static double font_table = Utils.setFontSize(20); //表格
  static double font_form = Utils.setFontSize(32); //表单
  /*分割线宽度*/
  static double border_colorTemperate = Utils.setWidth(6); //表单
  static double border_form = Utils.setWidth(1); //表单
  static double border_table = Utils.setWidth(1); //表格
  /*间隔*/
  static double gap_form = Utils.setWidth(16); //界面表单
  static double gap_view = Utils.setWidth(16); //视图表单
  /*高度*/
  static double header_view = Utils.setWidth(88); //模态视图header 高度
}

/*间隔*/
class Gaps {
  /*水平间隔*/
  static Widget gap_form = new SizedBox(width: Dimens.gap_form);
  static Widget gap_table = new SizedBox(width: Dimens.gap_form);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_form);

  /* 垂直间隔*/
  static Widget vGap5 = new SizedBox(height: Dimens.gap_form);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_form);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_form);
}

class Borders {
  static Decoration item = BoxDecoration(
      border:
          Border(bottom: BorderSide(width: Utils.setWidth(0.66), color: YColors.themeColor[0]['itemBottomBorder'])));
}

class Margins {
  static EdgeInsets item = EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0, top: 0.0);
}

class TextStyles {
  static TextStyle normal = TextStyle(color: ColorMap.text_color, fontSize: Dimens.normal); //85
  static TextStyle normalRight = TextStyle(color: ColorMap.text_color_secondary, fontSize: Dimens.normal); //65
  static TextStyle font_25_12 = TextStyle(color: ColorMap.text_color_disable, fontSize: Dimens.subTitle); //25 / 12
  static TextStyle font_100_12 = TextStyle(color: ColorMap.text_color, fontSize: Dimens.subTitle); //100 12
  static TextStyle font_100_16 = TextStyle(color: ColorMap.white, fontSize: Dimens.font_form); //100 12
  static TextStyle font_25_16 = TextStyle(color: ColorMap.text_color_disable, fontSize: Dimens.font_form); //100 12
  static TextStyle subTitle = TextStyle(color: ColorMap.text_color_third, fontSize: Dimens.subTitle); //45
  static TextStyle tip = TextStyle(color: ColorMap.text_color_disable, fontSize: Dimens.tip); //25
  static TextStyle active = TextStyle(color: ColorMap.active_color, fontSize: Dimens.normal); //蓝色字体
}
