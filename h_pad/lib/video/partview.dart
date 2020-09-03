import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:h_pad/style/index.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';
import 'package:h_pad/video/videoplayer.dart';

// 显示视频的视图-组件.
// 采用canvas实现.
class PartView extends CustomPainter {
  PartView({Key key, this.player, this.url, this.autoPlay, this.inputId, this.screenId, this.layerId, this.type, this.cutX, this.cutY, this.cutW, this.cutH, this.videoW, this.videoH, this.context, this.defaultColor});

  VideoPlayer player; // SDK对象实例
  String url;    // 视频URL，可以为空.目前未使用、预留参数
  bool autoPlay; // 视图创建时是否自动播放视频.目前未使用、预留参数
  int inputId;   // 输入ID
  int screenId;  // 屏幕ID
  int layerId;   // 图层ID
  int type;      // 视频类型(0-源;1-截取源/子源)
  int cutX;      // 截取坐标X(相对于源的坐标)
  int cutY;      // 截取坐标Y(相对于源的坐标)
  int cutW;      // 截取的宽(相对于源的宽)
  int cutH;      // 截取的高(相对于源的高)
  int videoW;    // 源的分辨率-宽
  int videoH;    // 源的分辨率-高
  BuildContext context; // 上下文
  Color defaultColor ; // 默认显示颜色

  @override
  void paint(Canvas canvas, Size size) {

    // 启用视频时从Provider中获得图片帧数据，否则采用默认图片.
    if (player.useVideo && VideoProvider != null && context != null) {
      VideoProvider videoProvider = Provider?.of<VideoProvider>(context, listen: false);
      ui.Image img = videoProvider?.image;

      if (null != img) {
        List<double> pos = player.calCopPosAD(type, cutX, cutY, cutW, cutH, videoW, videoH, inputId);

        var src = Rect.fromLTWH(pos[0], pos[1], pos[2], pos[3]);
        var dst = Rect.fromLTWH(0, 0, size.width, size.height);

        Paint paint = Paint();
        canvas.drawImageRect(img, src, dst, paint);
      }
    } else {
      _paintUseDefalutImage(canvas, size); // 显示默认图片
    }
  }

  // 采用默认图片渲染canvas.
  void _paintUseDefalutImage(Canvas canvas, Size size) {
    ui.Image img = player.defaultImage;

    if (null != img) {
      var src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
      var dst = Rect.fromLTWH(0, 0, size.width, size.height);

      if (defaultColor == null) {
        defaultColor = player.defaultColor;
      }

      Paint paint = Paint();
      // canvas.drawImageRect(img, src, dst, paint);
      paint.color = defaultColor;
      canvas.drawRect(dst, paint);
    }
  }

  @override
  bool shouldRepaint(PartView other) {
    return true;
  }
}
