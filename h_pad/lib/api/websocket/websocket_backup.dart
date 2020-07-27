/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-25 17:55:36
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-03 22:48:09
 */ 
import 'dart:async';
import 'dart:io';

import 'package:h_pad/common/component_index.dart';

class WebSocketUtil {
  static WebSocketUtil _instance; // WebSocketUtil 实例对象

  Future<WebSocket> socket; // WebSocketUtil 连接返回对象

  String url; // WebSocketUtil 连接url
  Function funCallbackReceiveData;
  Function funCallbackDataProcess;

  bool _reconnect = false;
  bool _forbidReconnect = false; // 手动关闭，禁止重连
  Timer _heartbeatTimer;
  Timer _reconnectTimer;
  WebSocket _webSocket;

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
    socket = WebSocket.connect(url);
    socket.then((WebSocket ws) {
      _webSocket = ws;
      _forbidReconnect = false; // 重置为false，系统断开了允许重连
      if (_webSocket.readyState == 1) { // 1：连接成功建立，可以进行通信
        // print('WebSocket连接成功，开始通信');
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
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
    try{
      close();
      _reconnectSocket();
    } catch (err) {
      print('释放再连接WebSocket出现错误=========$err');
    }
  }

  // 关闭Socket
  void close() {
    _closeTimer();
    _webSocket?.close();
    _webSocket = null;
    // print('关闭socket-------');
  }

  // 关闭Socket，禁止重连
  void closeManual(bool indicator) {
    _forbidReconnect = indicator;
    _closeTimer();
    _webSocket?.close();
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   print('关闭socket222=========》》》》》》》》》$_webSocket');
    // });
    _webSocket = null;
    print('关闭socket,禁止重连-------');
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

  // 重连
  void _reconnectSocket() {
    if (_reconnect || _forbidReconnect) {
      return;
    }

    _reconnect = true;

    _reconnectTimer ??= new Timer.periodic(Duration(seconds: 5), (timer) {
      open(url);
      _reconnect = false;
    });
    print('socket重连-------');
  }

  // 开始心跳检测
  void _startHeartbeat() {
    _heartbeatTimer ??= new Timer.periodic(Duration(seconds: 60), (timer) {
      try {
        _webSocket?.add('heartbeat');
        print('心跳=========${DateTime.now().toString()}');
      } catch (err) {
        print('发送心跳出现异常=========$err');
      }
    });
  }

  // 检测心跳
  void _checkHeartbeat() {
    _closeTimer();
    _startHeartbeat();
  }

  // 重置心跳、重连timer
  void _closeTimer() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }
}
