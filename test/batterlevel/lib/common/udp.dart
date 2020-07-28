import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h_pad/states/main/DeviceListProvider.dart';
import 'package:provider/provider.dart';

// udp 广播设备列表
// class InitUDP {
//   InitUDP(context) : this.context = context;
//   BuildContext context;
//   Timer _timer;
//   RawDatagramSocket _rawDatagramSocket;

//   void initUDP() {
//     RawDatagramSocket.bind(InternetAddress.anyIPv4, 8806).then((RawDatagramSocket udpSocket) {
//       _rawDatagramSocket = udpSocket;
//       _rawDatagramSocket.broadcastEnabled = true;
//       _rawDatagramSocket.listen((e) {
//         Datagram dg = _rawDatagramSocket.receive();
//         if (dg != null) {
//           print('搜索到的设备：${String.fromCharCodes(dg.data)}');
//           String str = String.fromCharCodes(dg.data);
//           Provider.of<DeviceListProvider>(context, listen: false).addDevice = json.decode(str);
//         }
//       });
//       List<int> data = utf8.encode('HSeries');
//       Provider.of<DeviceListProvider>(context, listen: false).clearDevice();
//       // print('发起广播： $data');
//       _rawDatagramSocket.send(data, InternetAddress('255.255.255.255'), 7788);
//       // 定点心跳
//       _timer = Timer.periodic(new Duration(seconds: 5), (timer) {
//         Provider.of<DeviceListProvider>(context, listen: false).clearDevice();
//         // print('发起广播： $data');
//         _rawDatagramSocket.send(data, InternetAddress('255.255.255.255'), 7788);
//       });
//     });
//   }

//   void mockDevice() async {
//     final listJson = await rootBundle.loadString('lib/mock/deviceList.json');
//     // print('listJson------------:$listJson');
//     List<dynamic> list = json.decode(listJson);
//     list.forEach((items) {
//       Provider.of<DeviceListProvider>(context, listen: false).addDevice = items;
//     });
//   }

//   void dispose() {
//     if (_timer != null) {
//       _timer.cancel();
//       _timer = null;
//     }
//     if (_rawDatagramSocket != null) {
//       _rawDatagramSocket.close();
//       _rawDatagramSocket = null;
//     }
//   }
// }

class Manager {
  // 工厂模式
  factory Manager(context) => _getInstance(context);
  static Manager get instance => _getInstance(_context);
  static Manager _instance;
  static BuildContext _context;
  Timer _timer;
  RawDatagramSocket _rawDatagramSocket;

  static Manager _getInstance(context) {
    if (_instance == null) {
      _instance = new Manager._internal(context);
    } else {
      //更新 context
      _context = context;
    }
    return _instance;
  }

  Manager._internal(context) {
    try {
      // 初始化
      if (context != null) {
        _context = context;
      }
      udpBind(context);
    } catch (e) {
      print('设备搜索绑定UDP时出现异常$e');
    }
  }

udpBind(context){
    _closeUpdBind();
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 8806).then((RawDatagramSocket udpSocket) {
        _rawDatagramSocket = udpSocket;
        _rawDatagramSocket.broadcastEnabled = true;
        List<int> data = utf8.encode('HSeries');
        // print('初始化发起广播： $data');
        _rawDatagramSocket.send(data, InternetAddress('255.255.255.255'), 7788);
        _rawDatagramSocket.listen((e) {
          try {
            Datagram dg = _rawDatagramSocket.receive();
            if (dg != null) {
              // print('搜索到的设备：${String.fromCharCodes(dg.data)}');
              String str = String.fromCharCodes(dg.data);
              Provider.of<DeviceListProvider>(context, listen: false).addDevice = json.decode(str);
            } else {
              print('设备搜索UDP收到的数据为空$dg');
            }
          } catch(e) {
            print('设备搜索结果异常----$e');
          }
        });
      }).catchError((error){
        print('socket绑定错误');
        udpBind(context);
      });
  }

  _closeUpdBind(){
    try {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      if (_rawDatagramSocket != null) {
        _rawDatagramSocket.close();
        _rawDatagramSocket = null;
      }
    } catch (e) {
      print('设备搜索关闭UDP时出现异常======$e');
    } 
  }
  // void mockDevice() async {
  //   final listJson = await rootBundle.loadString('lib/mock/deviceList.json');
  //   // print('listJson------------:$listJson');
  //   List<dynamic> list = json.decode(listJson);
  //   list.forEach((items) {
  //     Provider.of<DeviceListProvider>(_context, listen: false).addDevice = items;
  //   });
  // }

  // 重开 定时器
  bool onceAgain() {
    if(_rawDatagramSocket == null) return false;
    try {
      List<int> data = utf8.encode('HSeries');
      Provider.of<DeviceListProvider>(_context, listen: false).clearDevice();
      // print('手动刷新发起广播： $data');
      _rawDatagramSocket.send(data, InternetAddress('255.255.255.255'), 7788);
      return true;
    } catch(e) {
      print('设备搜索异常======$e');
      return false;
    }
  }

  void close() {
    _instance = null;
    _closeUpdBind();
  }
}
