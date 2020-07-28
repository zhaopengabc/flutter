import 'dart:async';
import 'dart:io';

import 'package:h_pad/common/component_index.dart';

class WebSocketUtil {
  static WebSocketUtil _instance; // WebSocketUtil 实例对象
  String url; // WebSocketUtil 连接url
  Function funCallbackReceiveData;
  Function funCallbackDataProcess;
  Timer _timer;
  WebSocket _webSocket;
  bool _forbidReconnect = false; 

  /*
   * 获取WebSocket实例
   * @param { bool } 如果isNewInstance为true，则创建新的对象，否则使用已有的实例
   */
  static WebSocketUtil getInstance({bool isNewInstance = false}) {
    if (_instance == null) {
      _instance = WebSocketUtil();
    }
    if (isNewInstance == true) {
      return WebSocketUtil();
    }
    return _instance;
  }

  // 构造方法
  _WebSocketUtil() {}

  // 打开Socket
  void open(String wsUrl) {
    url = wsUrl;
    // print('websocket wsUrl地址=========$wsUrl');
    WebSocket.connect(url).then((WebSocket ws) {
      _webSocket = ws;
      _forbidReconnect = false;
      if (_webSocket.readyState == 1) { // 1：连接成功建立，可以进行通信
        // print('WebSocket连接成功，开始通信');
        _timer?.cancel();
        // _reconnectTimer = null;
        _checkHeartbeat(); // 心跳
      }

      _webSocket.listen((onData) {
        try {
          // print('WebSocket监听数据$onData');
          _receiveData(onData);
        } catch (err) {
          print('WebSocket监听数据出现错误=========$err');
        }
      }, onError: (err) {
        print('WebSocket监听过程中出现错误=========${err.runtimeType.toString()}');
        _reconnectWs();
      }, onDone: () {
        print('WebSocket监听结束');
        _reconnectWs();
      });

    }).catchError((err) {
      print('WebSocket连接捕获异常=========$err=========$url');
      _reconnectWs();
    }).whenComplete(() {
      print('WebSocket whenComplete执行');
    });
  }

  // 处理接收到的数据
  void _receiveData(String data) {
    if (data != null) {
      if (funCallbackDataProcess != null) {
        dynamic res = funCallbackDataProcess(data); // 预处理返回的数据类型未知
        if (funCallbackReceiveData != null) {
          funCallbackReceiveData(res);
        }
      } else {
        if (funCallbackReceiveData != null) {
          funCallbackReceiveData(data);
        }
      }
    }
  }

  // 先释放再连接
  void _reconnectWs() {
    try {
      _webSocket?.close();
      _webSocket = null;
      _timer?.cancel();
      _reconnectSocket();
    } catch (err) {
      print('释放再连接WebSocket出现错误=========$err');
    }
  }

  // 关闭Socket
  void closeManual(bool indicator) {
    _forbidReconnect = indicator;
    _timer?.cancel();
    _timer = null;
    _webSocket?.close();
    _webSocket = null;
    unRegisterDataCallback();
    // print('关闭socket-------');
  }

  // 发送消息
  bool send(String data) {
    try {
      if (_webSocket != null) {
        _webSocket.add(data);
      } else {
        print('发送websocket数据失败： _webSocket为空');
      }
    } catch (e) {
      print('发送websocket异常：$e');
      return false;
    }
    return true;
  }

  /*
   * @description: 注册数据回调函数，如果参数/callbackDataProcess不为空时将会先调用该方法，并将此方法的返回值传递给callbackReceiveData
   * @param { Function } callbackReceiveData(dynamic data) 数据接收回调函数
   * @param { Function }  callbackDataProcess(String data) 数据预处理回调函数
   */
  void registerDataCallback(Function callbackReceiveData, {Function callbackDataProcess}) {
    funCallbackReceiveData = callbackReceiveData;
    funCallbackDataProcess = callbackDataProcess;
  }
  void unRegisterDataCallback() {
    funCallbackReceiveData = null;
    funCallbackDataProcess = null;
  }
  // 重连
  void _reconnectSocket() {
    if(_forbidReconnect) return;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      open(url);
    });
    print('socket重连-------');
  }

  // 检测心跳
  void _checkHeartbeat() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      try {
        _webSocket?.add('heartbeat');
        print('心跳=========${DateTime.now().toString()}');
      } catch (err) {
        print('发送心跳出现异常=========$err');
        _reconnectSocket();
      }
    });
  }
}
