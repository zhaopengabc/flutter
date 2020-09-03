import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:h_pad/video/videoparam.dart';
import 'package:h_pad/video/partview.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';

// 视频播放工具类/SDK.
// 目前不支持IOS,只支持Android系统播放视频.
class VideoPlayer {
  static Map _playerMap = new Map(); // 存储VideoPlayer实例的集合
  BuildContext _context; // 上下文
  VideoProvider _provider; // 存储图片帧数据Provider
  bool _initBln = false; // 记录是否已经初始化过
  MethodChannel _mainChannel; // 与android通讯的channel
  VideoParam _initItem; // 视频链接所需的参数对象
  ui.Image _defaultImage; // 默认图片,不启用视频时显示该图片
  Timer _timeGetImage; // 周期获取图片帧数据的Timer
  bool _useVideo = true; // 是否启用视频[true-启用；false-不启用]
  bool _taskSts = false; // 任务状态[true-工作中；false-未工作]
  int _delayFreeFrameNum = 5; // 延迟释放图片的帧数
  List<ui.Image> _cachesToDel = List<ui.Image>(); // 缓存要销毁的图片
  Color defaultColor = Color(0xFF38ADB7); // 默认显示颜色

  // 外部不要调用此方法，使用getInstance方法获得实例.
  VideoPlayer() {
    try {
      _loadDefaultImage().then((ui.Image onValue) {
        // 加载默认图片
        this._defaultImage = onValue;
      });

      //  if (Platform.isIOS) { // 不支持IOS视频时需要将此if打开
      //    _useVideo = false;
      //  }

      if (!_useVideo) {
        return;
      }

      _mainChannel =
          new MethodChannel('plugins.video/playerSDK'); // 加载与android通讯的channel
    } catch (e) {
      print('VideoPlayer构造函数中发生异常：$e');
    }
  }

  // 获得VideoPlayer实例.
  //  参数：
  //    videoId：视频标识.不同的视频标识对应不同的VideoPlayer实例.
  //  返回值：VideoPlayer实例
  static VideoPlayer getInstance(String videoId) {
    VideoPlayer player = _playerMap[videoId];

    if (null != player) {
      return player;
    } else {
      player = new VideoPlayer();
      _playerMap[videoId] = player;
      return player;
    }
  }

  // 初始化.只调用一次即可.如果context发生了变化则需要再次调用.
  void init(BuildContext context) async {
    try {
      if (!_useVideo) {
        return;
      }
      if (null == context) {
        print("初始化-失败：context为空!");
        return;
      }

      _context = context;
      _provider = Provider.of<VideoProvider>(_context, listen: false);

      if (_initBln) {
        print("初始化接口被调用：已经初始化过、context若无变化则无需多次调用!");
        return;
      }

      if (null != _mainChannel) {
        int code = await _mainChannel.invokeMethod("init");
      } else {
        print("初始化-失败：mainChannel为空!");
      }

      this._startTimer(); // 开启轮询获取图片帧数据的Timer
      _initBln = true;
    } catch (e) {
      print("初始化时发生异常：$e");
    }
  }

  // 开启轮询获取图片帧数据的Timer.
  void _startTimer() {
    _timeGetImage = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (_taskSts) {
        _getImage().then((ui.Image onValue) {
          try {
            if (null != onValue && null != _provider) {
              _provider.image = onValue;
              _freeImage(onValue);
            }
          } catch (e) {
            print('VideoProvider已经dispose, 视频播放失败！$e');
          }
        });

//        if (Platform.isIOS) {
//          _getStatus(); // 外加方法，只针对IOS使用
//        }
      } else {
        // print("任务停止-不再调用获取帧数据接口");
      }
    });
  }

  // 从android中获得图片帧数据/大图.
  Future<ui.Image> _getImage() async {
    ui.Image rs;
    Uint8List imageData;

    try {
      final result = await _mainChannel.invokeMethod('getImageFrame');

      if (null != result) {
        imageData = result;
        ui.Codec codec = await ui.instantiateImageCodec(imageData,
            targetWidth: VideoParam.w, targetHeight: VideoParam.h);
        ui.FrameInfo fi = await codec.getNextFrame();
        rs = fi.image;

        codec.dispose();
        codec = null;
      }
    } on PlatformException {
      imageData = null;
      rs = null;
    }

    return rs;
  }

  // 延时释放图片.
  // 缓存中图片数量达到指定的数量后释放掉旧的图片.从而变相实现延迟释放图片.
  void _freeImage(ui.Image img) {
    _cachesToDel.insert(0, img);

    if (_cachesToDel.length >= _delayFreeFrameNum) {
      _cachesToDel.last.dispose();
      _cachesToDel.removeLast();
    }
//    print("释放图片! length:${_cachesToDel.length}");
  }

  // 加载默认图片
  Future<ui.Image> _loadDefaultImage() async {
    ui.Image img;

    try {
      ByteData data = await rootBundle.load('assets/images/input/input1.png');
      ui.Codec codec =
          await ui.instantiateImageCodec(data.buffer.asUint8List());
      ui.FrameInfo fi = await codec.getNextFrame();
      img = fi.image;
    } catch (e) {
      print("加载默认图片时发生异常：$e");
    }

    return img;
  }

  // 创建切割任务
  void createCutTask(VideoParam param) async {
    try {
      _initItem = param;

      if (!_useVideo) {
        return;
      }
      if (null != _mainChannel) {
        int code = await _mainChannel.invokeMethod("startTask", {
          "url": param.url,
          "row": param.cutRow,
          "column": param.cutColumn,
          "w": param.width,
          "h": param.height,
          "displayVideo": param.displayVideo
        });
        _taskSts = true;
      } else {
        print("创建切割任务-失败：mainChannel为空!");
      }
    } catch (e) {
      print("创建切割任务时发生异常：$e");
    }
  }

  // 停止切割任务
  void stopCutTask() async {
    if (!_useVideo) {
      return;
    }
    try {
      if (null != _mainChannel) {
        int code = await _mainChannel.invokeMethod("stopTask");
        _taskSts = false;
      } else {
        print("停止切割任务-失败：mainChannel为空!");
      }
    } catch (e) {
      print("停止切割任务时发生异常：$e");
    }
  }

//  // 查询状态并根据条件调用startTask.只针对IOS使用.
//  void _getStatus() async {
//    if (!_useVideo) {
//      return;
//    }
//    try {
//      if (null != _mainChannel) {
//        int code = await _mainChannel.invokeMethod("getStatus");
//
//        if (code == 1) {
//          if (_initItem != null) {
//            int code = await _mainChannel.invokeMethod("startTask", {"url": _initItem.url,"row":_initItem.cutRow, "column":_initItem.cutColumn,"w":_initItem.width,"h":_initItem.height, "displayVideo":_initItem.displayVideo});
//            print("查询状态-并调用startTask()方法!");
//          } else {
//            print("查询状态-失败：_initItem为空!");
//          }
//        }
//      } else {
//        print("查询状态-失败：mainChannel为空!");
//      }
//    } catch (e) {
//      print("查询状态时发生异常：$e");
//    }
//  }

  // 切源.
  // type:0-源;1-截取源/子源
  void changeVideoIndexByViewId(int viewId, int videoIndex, int type, int cutX,
      int cutY, int cutW, int cutH, int videoW, int videoH) async {}

  // 切源.
  // type:0-源;1-截取源/子源
  void changeVideoIndexByLayerId(
      int screenId,
      int layerId,
      int videoIndex,
      int type,
      int cutX,
      int cutY,
      int cutW,
      int cutH,
      int videoW,
      int videoH) async {}

  // 创建切割播放视图.
  // 参数：
  //   inputId:输入ID
  //   screenId:屏幕ID
  //   layerId:图层ID
  //   type:视频类型(0-源;1-截取源/子源)
  //   cutX:截取坐标X(相对于源的坐标)
  //   cutY:截取坐标Y(相对于源的坐标)
  //   cutW:截取的宽(相对于源的宽)
  //   cutH:截取的高(相对于源的高)
  //   videoW:截取所用父源的分辨率-宽
  //   videoH:截取所用父源的分辨率-高
  //   context:上下文
  //   url:[可选参数]视频URL，可以为空.目前未使用、预留参数
  //   autoPlay:[可选参数]视图创建时是否自动播放视频.目前未使用、预留参数
  // 返回值：
  //   Widget/显示视频的视图
  Widget createView(
      int inputId,
      int screenId,
      int layerId,
      int type,
      int cutX,
      int cutY,
      int cutW,
      int cutH,
      int videoW,
      int videoH,
      BuildContext context,
      {String url,
      bool autoPlay = true,
      Color defaultColor}) {
    try {
      return CustomPaint(
        painter: PartView(
            player: this,
            url: url,
            autoPlay: autoPlay,
            inputId: inputId,
            screenId: screenId,
            layerId: layerId,
            type: type,
            cutX: cutX,
            cutY: cutY,
            cutW: cutW,
            cutH: cutH,
            videoW: videoW,
            videoH: videoH,
            context: context,
            defaultColor: defaultColor),
      );
    } catch (e) {
      print("创建切割播放视图时发生异常：$e");
    }
  }

  // 计算源或截取源在大图“8*8布局中”的坐标尺寸.
  // 参数：
  //  type:视频类型(0-源;1-截取源/子源)
  //  cutX:截取坐标X(相对于源的坐标)
  //  cutY:截取坐标Y(相对于源的坐标)
  //  cutW:截取的宽(相对于源的宽)
  //  cutH:截取的高(相对于源的高)
  //  videoW:截取所用父源的分辨率-宽
  //  videoH:截取所用父源的分辨率-高
  // 返回值：List<int>计算后的坐标*尺寸([0]:X、[1]:Y、[2]:W、[3]:H)
  List<double> calCopPosAD(int type, int cutX, int cutY, int cutW, int cutH,
      int videoW, int videoH, int inputId) {
    // 小图尺寸
    int sImgW = (_initItem.width / _initItem.cutColumn).floor();
    int sImgH = (_initItem.height / _initItem.cutRow).floor();

    // 小图在大图中的行列号
    int rowNo = (inputId / _initItem.cutColumn).floor();
    int colNo = inputId % _initItem.cutColumn;

    // 小图在大图上的坐标
    int x = (colNo * sImgW).floor();
    int y = (rowNo * sImgH).floor();

    List<double> rs = [
      x?.toDouble(),
      y?.toDouble(),
      sImgW?.toDouble(),
      sImgH?.toDouble(),
      videoW?.toDouble(),
      videoH?.toDouble(),
      inputId?.toDouble()
    ];

    // 截取源/子源时坐标尺寸需要重新计算:计算在大图上的坐标、尺寸.
    if (1 == type) {
      double rx = cutX * sImgW / videoW;
      double ry = cutY * sImgH / videoH;
      double rw = cutW * sImgW / videoW;
      double rh = cutH * sImgH / videoH;

      rs[0] = rx + x;
      rs[1] = ry + y;
      rs[2] = rw;
      rs[3] = rh;
    }

    return rs;
  }

  bool get useVideo => _useVideo;
  ui.Image get defaultImage => _defaultImage;
  bool get initBln => _initBln;
}
