import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/api/code.dart';
import 'package:h_pad/api/result.dart';
import 'package:h_pad/common/global.dart';

class HttpClient {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  HttpClient(this.context) {
    _options = Options(extra: {"context": context});
    // print("初始化HttpClient参数");
  }
  BuildContext context;
  Options _options;

  static Dio dio = new Dio(BaseOptions(
    baseUrl: Global.getBaseUrl,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cacheControlHeader: 'no-cache',
    },
    connectTimeout: 15000,
    receiveTimeout: 5000,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // when no parameters are sent
      if (options.data == null) {
        options.data = {};
      }

      // 获取 Global.profile.token 存储的登录返回 token
      // options.headers['token'] =  'gAN9cQAoWAIAAABpZHEBSwFYAwAAAGtleXECWCAAAAAyMTIzMmYyOTdhNTdhNWE3NDM4OTRhMGU0YTgwMWZjM3EDWAQAAAB0aW1lcQRHQdeVTSU7pFR1Lg==';
      options.headers['token'] = Global.getToken;
      // print('options.headers[token]:${options.headers['token']}');
      // print('interceptors: ${dio.options.baseUrl}');
      // print('初始化HttpClient');
      return options; //continue
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError e) {
      // Do something with response error
      Fluttertoast.showToast(msg: '${e.message}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP);
      return e;
    }));

    // // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    // if (!Global.isRelease) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    //     client.findProxy = (uri) {
    //       return "PROXY 10.1.10.250:8888";
    //     };
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  /*
   * @description: 发起网络请求（异步方式）
   * @param { String }  url 请求路径
   * @param { Map }  data 请求数据
   * @param { Options }  options 请求配置信息
   * @param { CancelToken }  可以通过 cancel token 来取消发起的请求
   * @param { List }  passCodeList 外部处理码集合，对其指定的码内部不进行处理
   * @param { int } sendTimeout 发送 超时时间
   * return { Result }
   *
   */
  Future<Result> request(url, {data, method, cancelToken, sendTimeout = 0, List<int> passCodeList}) async {
    data = data ?? {};
    passCodeList = passCodeList ?? [];
    _options.method = method ?? 'POST';
    if (sendTimeout != 0) {
      _options.sendTimeout = sendTimeout;
    }
    Response response;
    try {
      response = await dio.request(url, data: data, options: _options, cancelToken: cancelToken);
    } on DioError catch (e) {
      return Future.error(handlerError(e));
    }
    if (response.data is DioError) {
      return Future.error(handlerError(response.data));
    }
    print('ModalRoute.of(context).settings.name: ${ModalRoute.of(context).settings.name}');
    // 统一内部处理特殊业务编码
    if (passCodeList.length == 0 && response.data['status'] != 0) {
      // print('response.data.msg: ${response.data['msg']}');
      // 特殊处理状态
      if (response.data.status > 105 && response.data.status < 109 ||  response.data.status == 101) {
        // print("要跳转到登录页2");
        // token 过期
        Navigator.pushNamed(_options.extra['context'], 'Login');
      } else if (response.data.status == 912) {
        // router.push('/loading');
        Navigator.pushNamed(_options.extra['context'], 'Init');
      } else if (response.data.status == 913) {
        // let path = store.state.user.token ? '/Settings/Upgrade' : '/loading';
        // router.push(path);
        Navigator.pushNamed(_options.extra['context'], 'Init');
      } else if (response.data.status == 914) {
        // store.commit('device/setShowSelfCheck', true);
        // router.push('/checking');
        Navigator.pushNamed(_options.extra['context'], 'Init');
      }
      Fluttertoast.showToast(
          msg: '${response.data.msg}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);
      // handlerError(response.data)
      return Future.error(response);
    }
    return Result(response.data['status'], response.data['msg'], response.data['data']); // 返回业务数据
  }

  // 网络请求错误处理
  handlerError(e) {
    if (e is DioError) {
      Response errorResponse;
      print('报错数据e:$e');
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 888);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
        // return Result(-1, '网络请求 超时', null);
      }
      Fluttertoast.showToast(msg: '网络请求错误', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP);
      return Result(errorResponse.statusCode, errorResponse.statusMessage, null);
    } else {
      return Result(e.code, e.msg, null);
    }
  }

  /*
   * 取消请求
   * 一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消，所以参数可选。
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
