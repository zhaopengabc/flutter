import 'package:flutter/material.dart';

class ColorMap {
  static const Color app_main = Color(0xFF000000);

  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFFB8B8B8);
  static const Color text_gray = Color(0xFF999999);

  static const Color divider = Color(0xffe5e5e5);

  static const Color active_color = Color(0xFF3F90FF);
  /*字体颜色*/
  static const Color view_font = Color(0xFF333333);
  static const Color view_font_tip = Color(0xFF757575);
  static const Color page_font_tip = Color(0xffffffff);
  static const Color page_font = Color(0xffffffff);
  static const Color noDevice_font = Color(0xff797979);
  static const Color version_font = Color(0xff8D8D8D);
  static const Color del_font = Color(0xff353535);
  static const Color txt_font_color = Color(0xffDCDCDC);
  /*背景色*/
  static const Color form_bg = Color(0xFF333333);
  static const Color view_bg = Color(0xF5F5F5F5);
  static const Color dialog_bg = Color(0xffffffff);
  static const Color toast_bg = Color(0xFF333333);
  static const Color layer_bg = Color(0xff131313);
  static const Color layer_bg_nostream = Color(0xbb24242B);
  static const Color layer_bg_template = Color(0x8824242B);
  /*色温*/
  static const Color colorTemperate_bg_0 = Color(0xFFE0FFFB);
  static const Color colorTemperate_bg_1 = Color(0xFFEBF8FF);
  static const Color colorTemperate_bg_2 = Color(0xFFFFF5F1);
  static const Color colorTemperate_font_0 = Color(0xFF0F9886);
  static const Color colorTemperate_font_1 = Color(0xFF373737);
  static const Color colorTemperate_font_2 = Color(0xFFBE7456);
  /*屏体状态*/
  static const Color scree_online = Color(0xFF55C860);
  static const Color scree_offline = Color(0xFFFFA941);
  static const Color scree_unlogin = Color(0xFFE6E6E6);
  /*表单色*/
  static const Color form_form_bg = Color(0xFF333333);
  static const Color view_form_bg = Color(0xE0FFFFFF);

  // -------- Colors -----------
  static const Color primary_color = Color(0xFF3F90FF); // 全局主色*
  static const Color success_color = Color(0xFF55C860); // 成功色
  static const Color error_color = Color(0xFFFB4B3A); // 错误色
  static const Color warning_color = Color(0xFFFFA941); // 警告色
  static const Color white = Color(0xFFFFFFFF); // 白色
  static const Color black = Color(0xFF000000); // 黑色
  static const Color grey = Color(0xFF949494); // 灰色
  static const Color modal_mask = Color(0x4D000000); // 模态框背景蒙层【0x4D000000】
// Link
  static const Color link_color = Color(0xFF3F90FF); // 链接色
// Disabled states
  static const Color disabled_color = Color(0xFFFAFAFA); // 禁用色
// Background color
  static const Color body_bg = Color(0xFFF5F5F5); // 全局背景色
  static const Color component_bg = Color(0xFFFFFFFF); // 组件背景色
  static const Color tabbar_bg = Color(0xFFFAFAFA); // TabBar 背景色
  
// Border color
  static const Color border_color_split = Color(0xFF4B4B4B); // 组件分割线 //step背景色
  static const Color border_color_tabbar = Color(0xFFBFBFBF); // TabBar 分割线
  static const Color border_color_item = Color(0xFF08070C); // 列表项底部边框
  static const Color border_color_bottomLine = Color(0xFF8D8D8D);
  // Button color
  static const Color button_bg = Color(0xFFF5F5F5); // 按钮
  static const Color button_bg_del = Color(0xFFE6323A); // 按钮
  static const Color btn_auth = Color(0xFF4C97F0);
// Shadow
  static const Color shadow_color = Color(0x1A192832); // 阴影【0x19192832】
//  static const Color shadow_navbar: 0 2px 6px @shadow-color; // 导航栏阴影
//  文字

// Normal
  static const Color text_color = Color(0xD9000000); // 85%标题色、主文本色【0xD8000000】
  static const Color text_color_secondary =
      Color(0xA6000000); // 65%次文本色【0xA5000000】
  static const Color text_color_third =
      Color(0x73000000); // 45%次文本色【0x73000000】
  static const Color text_color_disable =
      Color(0x40000000); // 25%hint语、禁用文本色【0x3F000000】
  static const Color text_color_active = primary_color; // 激活文字色*
  static const Color text_selection_bg = primary_color; // 文本选中背景色*
  static const Color text_color_inverse = Color(0xFFFFFFFF); // 反转文本色

// Dark background
  static const Color text_color_dark = Color(0xFFFFFFFF); // 深色标题色、主文本色
  static const Color text_color_secondary_dark =
      Color(0xD9FFFFFF); // 深色次文本色【0xD8FFFFFF】
  static const Color text_color_disable_dark =
      Color(0x73FFFFFF); // 深色hint语、禁用文本色【0x72FFFFFF】
  static const Color bkg_auth =
      Color(0xFF2D2D2D); //授权窗口背景色

//  图标
  static const Color icon_color = text_color; // 功能图标继承文本色

//  组件
// Buttons
  static const Color btn_primary_bg = primary_color; // 主按钮背景色*
  static const Color btn_danger_bg = error_color; // 危险按钮背景色
  static const Color btn_disable_bg = disabled_color; // 禁用按钮背景色

// Checkbox/Radio
  static const Color checkbox_color = primary_color; // 单选、多选图标色*

// Radio buttons
  static const Color radio_button_bg = disabled_color; // 单选按钮未激活背景色
  static const Color radio_button_checked_bg = primary_color; // 单选按钮选中背景色*

// Popover
  static const Color popover_bg = Color(0xD9000000); // 气泡弹出框背景色【0xD8000000】

// Modal
//  static const Color modal_bg: @white, 15% transparent; // 模态框背景色（15% 背景模糊）
  static const Color modal_border_color_split =
      border_color_split; // 模态框、模态面板、模态视图分割线

// DatePicker
  static const Color Date_picker_selected_bg = primary_color; // 日期选择器选中背景色*

// Badge
  static const Color badge_bg = error_color; // 徽标背景色

// Tabs
  static const Color tabs_active_color = primary_color; // 标签激活色*

// Switch
  static const Color switch_on_bg = success_color; // 开关启用背景色
  static const Color switch_off_bg = border_color_split; // 开关禁用背景色
//  static const Color switch_shadow_right: 2px 2px 8px @shadow-color; // 开关启用圆点阴影
//  static const Color switch_shadow_left: -2px 2px 8px @shadow-color; // 开关禁用圆点阴影

// Slider
  static const Color slider_active_color = primary_color; // 滑动输入条激活色*
  static const Color slider_track_color = border_color_split; // 滑动输入条轨道背景色
  static const Color slider_dot_border_color = border_color_split; // 滑动输入条圆点边框色
  static const Color slider_dot_shadow = shadow_color; // 滑动输入条圆点阴影
  static const Color slider_valueIndicator_color = Color(0xffD2D2D2); //气泡颜色
//图表配置
  static const Color charts_line = Color(0xff58CAFA);

// 选中的橘黄色
  static const Color orange_selected = Color(0xffE67007);

  static const Color user_background = Color(0xff24242B);
  static const Color header_background = Color(0xff2C2C33);
  static const Color user_font_color = Color(0xff989898);

  static const Color input_background_normal = Color(0xFF64646D);
  static const Color input_background = Color(0xff3A3A44);
  static const Color input_border_color = Color(0xff000000);
  static const Color input_bg_auth = Color(0xFF1A1A1A); // 输入框背景色

  static const Color slider_activeColor = Color(0xff2F78CF);
  static const Color slider_inactiveColor = Color(0xff474750);
  static const Color button_font_color = Color(0xffBFBFBF);
  static const Color mask_toolBkg_color =
      Color.fromRGBO(128, 128, 128, 0.5); // 遮罩背景色
  static const Color btnLoginout_bkg_color = Color(0xff595964); //退出按钮颜色

  static const Color screen_color = Color(0xff3E3E48); // 屏幕背景色
  static const Color screen_color_transparent = Color(0x683E3E48); // 屏幕背景色
  static const Color screen_border_color = Color(0xff999999); // 屏幕边框色
  static const Color layer_border_color = Color(0xff999999); // 图层边框色
  static const Color splitScreen_text_color = Color(0xffBFBFBF); // 分屏模块字体颜色
  static const Color splitScreen_border_color = Color(0xff2b2b2b); // 分屏模块边框颜色
  static const Color mask_bkg_color = Color.fromRGBO(0, 0, 0, 0.8); // 遮罩背景色
  static const Color mask_preset_poll_color =
      Color.fromRGBO(0, 0, 0, 0.7); // 场景轮巡遮罩背景色
  static const Color mask_layer_color = Color.fromRGBO(0, 0, 0, 0.5); // 遮罩背景色
  static const Color border_layer_color = Color(0xffEBEBEB); // 图层边框颜色

  static const Color preset_tabbar_background =
      Color(0xFF121212); // 场景tabbar背景色
  static const Color preset_tabbar_start =
      Color(0xFFB5B5B5); // 场景tabbar背景渐变色start
  static const Color preset_tabbar_end = Color(0xFF64646D); // 场景tabbar背景渐变色end
  static const Color press_bkg_color = Color(0xFF24242B); // 分屏按钮按下后的背景色

  static const Color screen_bkg_color = Color(0xFF121212); //屏幕空白区背景
  static const Color layer_noSource_color = Color(0xFF38ADB7); //无源图层
  static const Color layer_noSignal_color = Color(0xFF397FC4); //无信号图层
  static const Color toast_error_color = Color(0xFFA32727); //错误提示颜色
  static const Color layer_operating_bkg_color = Color(0xFFB03030); //正在修改提示背景颜色

  static const Color button_disabled_color = Color(0xFF23446E); //按钮禁止点击

  static const Color img_normal = Color(0xFFB8B8B8);
  static const Color img_disabled = Color(0xFF656565);

  static const Color indicator = Color(0xffe5e5e5);

  //边框颜色
  static const Color border_auth = Color(0xff545454);
}
