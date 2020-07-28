import 'dart:async';
// import 'dart:html';
import 'dart:typed_data';
// import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_ijk_example/video.dart';
// import 'package:flutter/src/widgets/basic.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

// 视频初始化参数
class VideoParam {
  String url; // RTSP地址
  bool cut; // 切割模式 true/false
  bool origin; // 显示模式
  int cutRow; // 切割行数
  int cutColumn; // 切割列数
  int width; // 视频分辨率-宽度
  int height; // 视频分辨率-高度
  int displayVideo; // 是否显示视频[1-是;0-否]

  static const int w = 1920; // 视频分辨率-宽度
  static const int h = 1080; // 视频分辨率-宽度
  static const int row = 8; // 切割行数
  static const int col = 8; // 切割列数

//  VideoParam(this.url, this.cut, this.origin, this.cutRow, this.cutColumn, this.width, this.height, this.displayVideo);
  VideoParam(this.url,
      {this.cut = true,
      this.origin = true,
      this.cutRow = row,
      this.cutColumn = col,
      this.width = w,
      this.height = h,
      this.displayVideo = 1});
}

class MyApp extends StatelessWidget {
  // 执行切割任务
  String url = "rtsp://192.168.10.95:8554/h264ESVideoTest";

  // , bool videoState
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");

  // var params = VideoParam(url);

  // sdk.createCutTask(new ); // displayVideo: videoState?0:1

  // var cut_task = cutTask(); // 存储VideoPlayer实例的集合
  // cut_task.createTask(url);
  // cut_task();
  //  VideoPlayerController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: Text(sdk.createCutTask(new VideoParam(url))),
      ),
    );
  }
}

// class cutTask {
//   String url;

//   // cutTask(url);
//   void createTask(url) {
//     // , bool videoState
//     VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");
//     sdk.createCutTask(new VideoParam(url)); // displayVideo: videoState?0:1
//   }
// }

class VideoPlayer {
  static Map _playerMap = new Map(); // 存储VideoPlayer实例的集合

  MethodChannel _mainChannel; // 与android通讯的channel
  bool _useVideo = true; // 是否启用视频
  // Timer _timeGetImage; // 周期获取图片帧数据的Timer

  // 不要调用此方法，使用getInstance方法获得实例.
  VideoPlayer() {
    try {
      _mainChannel =
          new MethodChannel('plugins.video/playerSDK'); // 加载与android通讯的channel

      print("create channel plugins.video/playerSDK ");
    } catch (e) {
      print('VideoPlayer构造函数中发生异常：$e');
    }
  }

  // // 开启轮询获取图片帧数据的Timer.
  // void _startTimer() {
  //   _timeGetImage = Timer.periodic(Duration(milliseconds: 60), (timer) {
  //     _getImage().then((ui.Image onValue) {
  //       try {
  //         if (null != onValue && null != _provider) {
  //           _provider.image = onValue;
  //         }
  //       } catch (e) {
  //         print('VideoProvider已经dispose, 视频播放失败！');
  //       }
  //     });
  //   });
  // }
  // 获得VideoPlayer实例.
  static VideoPlayer getInstance(String videoId) {
    VideoPlayer player = _playerMap[videoId];

    if (null != player) {
      return player;
    } else {
      player = new VideoPlayer();
      _playerMap[videoId] = player;
      print("player new ......");
      return player;
    }
  }

  // 初始化.只调用一次即可.如果context发生了变化则需要再次调用.
  void init(BuildContext context) async {
    try {
      if (null != _mainChannel) {
        int code = await _mainChannel.invokeMethod("init");
      } else {
        print("初始化-失败：mainChannel为空!");
      }
    } catch (e) {
      print("初始化时发生异常：$e");
    }
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
            targetWidth: 1920, targetHeight: 1080);
        ui.FrameInfo fi = await codec.getNextFrame();
        rs = fi.image;
      }
    } on PlatformException {
      imageData = null;
      rs = null;
    }

    return rs;
  }

// 创建切割任务
  dynamic createCutTask(VideoParam param) async {
    String code;
   code = await _mainChannel.invokeMethod("init");

    print("=========init $code  =========");

    try {
      // _initItem = param;

      if (null != _mainChannel) {
        code = await _mainChannel.invokeMethod("startTask", {
          "url": param.url,
          "row": param.cutRow,
          "column": param.cutColumn,
          "w": param.width,
          "h": param.height,
          "displayVideo": param.displayVideo
        });
      } else {
        print("创建切割任务-失败：mainChannel为空!");
      }
    } catch (e) {
      print("创建切割任务时发生异常：$e");
    }
    return code;
  }

// 停止切割任务
  stopCutTask() async {
    if (!_useVideo) {
      return;
    }
    try {
      if (null != _mainChannel) {
        int code = await _mainChannel.invokeMethod("stopTask");
      } else {
        print("停止切割任务-失败：mainChannel为空!");
      }
    } catch (e) {
      print("停止切割任务时发生异常：$e");
    }
    // finally {
    //   _timeGetImage?.cancel();
    //   _provider = null;
    //   _initBln = false;
    // }
  }
}
