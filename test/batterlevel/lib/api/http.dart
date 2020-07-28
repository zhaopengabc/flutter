import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_pad/api/api.dart';
import 'package:h_pad/api/code.dart';
import 'package:h_pad/api/result.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/common/global.dart';
import 'package:h_pad/style/colors.dart';

class HttpUtil {
  Dio _dio;
  BaseOptions baseOptions;
  BuildContext _context;
  Options _options;
  CancelToken cancelToken = CancelToken();

  List<int> codeList = List(); // 不需要内部处理的码列表

  bool _isLocal = true; // true-可以跳转。false-禁止跳转

  static HttpUtil _instance;
  List<HttpUtil> _instanceList = List(); // 存放isNewInstance为true时新new的实例

  /*
   * 获取网络请求实例
   * @param { isNewDevice } 如果isNewDevice为true，初始化时切换设备，清空已有的实例
   * @param { bool } 如果isNewInstance为true，则创建新的对象，否则使用已有的实例
   */
  HttpUtil getInstance({bool isNewDevice = false, bool isNewInstance = false}) {
    if (isNewDevice) {
      if (_instanceList.length != 0) {
        _instanceList.forEach((element) {
          element = null;
        });
        _instanceList.clear();
      }
      _instance = HttpUtil(_context);
      return _instance;
    }
    if (_instance == null) {
      _instance = HttpUtil(_context);
    }
    if (isNewInstance == true) {
      var httpUtil = HttpUtil(_context);
      _instanceList.add(httpUtil);
      return httpUtil;
    }
    return _instance;
  }

  /*
   * https://github.com/flutterchina/dio/tree/flutter/example
   */
  HttpUtil(context) {
    // print('ip: ${Global.getBaseUrl}');
    if (context != null) {
      // 使用HttpUtil时上下文
      _context = context;
    }
    _options = Options(extra: {"context": context});
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    baseOptions = BaseOptions(
      // 请求基地址,可以包含子路径，如: "https://www.google.com/api/"
      //baseUrl: Api.BASE_URL,
      baseUrl: Global.getBaseUrl,
      // 连接服务器超时时间，单位是毫秒
      connectTimeout: 15000,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]
      // [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常
      // 注意: 这并不是接收数据的总时限
      receiveTimeout: 5000,
      // Http请求头
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cacheControlHeader: 'no-cache',
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(baseOptions);
    // 添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // when no parameters are sent
      if (null == options.data) {
        options.data = {};
      }
      // 获取share_preference存储的登录返回token
      options.headers['token'] = Global.getToken;
      return options;
    }, onResponse: (Response response) {
      return response.data;
    }, onError: (DioError e) {
      // Do something with response error
      print('response拦截器拦截错误-----------$e');
      httpError(e, context, true);
      return e;
    }));
  }

  //http错误拦截处理逻辑
  httpError(DioError e, BuildContext context, bool showTip){
      String msgErr;
      int errCode;

      if (e.message.contains('Network is unreachable')) {
        errCode = Code.NETWORK_UNREACHABLE;
        if (!checkCode(codeList, Code.NETWORK_UNREACHABLE)) {
          // 50000
          msgErr = '网络未连接，请检查网络设置';
        } else {
          msgErr = null;
        }
      } else if (e.message.contains('No route to host')) {
        errCode = Code.NETWORK_NO_HOST;
        if (!checkCode(codeList, Code.NETWORK_NO_HOST)) {
          // 50001
          msgErr = '操作失败，请检查设备是否在网络中';
        } else {
          msgErr = null;
        }
      } else if (e.message.contains('Connecting timed out')) {
        errCode = Code.NETWORK_TIMEOUT;
        if (!checkCode(codeList, Code.NETWORK_TIMEOUT)) {
          // 50002
          msgErr = '操作失败，请重试！网络通信超时';
        } else {
          msgErr = null;
        }
      } else {
        errCode = Code.OTHER_CODE;
        msgErr = '${Translations.of(context).text("message.http10500")}';
      }
      if (showTip) {
        if (null != msgErr) {
          Fluttertoast.showToast(
              msg: msgErr,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: ColorMap.toast_error_color,
              textColor: ColorMap.white,
              gravity: ToastGravity.TOP);
        }
      }

      return errCode;
  }
  /*
   * 判断指定的code在passCodeList中是否存在.
   * return { bool } true-存在;false-不存在.
   */
  bool checkCode(List<int> passCodeList, int code) {
    if (passCodeList.length != 0) {
      return passCodeList.contains(code) ? true : false;
    } else {
      return false;
    }
  }

  /*
   * @description: 发起网络请求（异步方式）
   * @param { String }  url 请求路径
   * @param { Map }  data 请求数据
   * @param { Options }  options 请求配置信息
   * @param { CancelToken }  可以通过 cancel token 来取消发起的请求
   * @param { List }  passCodeList 外部处理码集合，对其指定的码内部不进行处理
   * return { Result } 改方法不会返回异常，只会返回Result对象
   */
  Future<Result> request(url,
      {data,
      method,
      cancelToken,
      sendTimeout = 0,
      List<int> passCodeList}) async {
    // print('请求的URL-----$url-----${_instance?.baseOptions?.baseUrl}');
    try {
      data = data ?? {};
      _options.method = method ?? 'POST';
      if (sendTimeout != 0) {
        _options.sendTimeout = sendTimeout;
      }
      passCodeList = passCodeList ?? List(); // 初始化passCodeList, 为null则返回新的List
      codeList = passCodeList;

      Response response;
      try {
        response = await _dio.request(url,
            data: data, options: _options, cancelToken: cancelToken);
        if (response?.data is DioError) {
          // print('判断DioError-----------http错误');
          return handlerError(response.data);
        }
        // print('服务返回状态码-----${response.data['status']}');
      } on DioError catch (e) {
        print('DioError------http错误-----$e');
        return handlerError(e);
      } catch (e) {
        print('请求接口错误-----------$e');
        return new Result(99999, null, null);
      }

      //Android网络超时时没有返回值，返回值类型是RequestOptions
      if (Platform.isAndroid &&
          response.data.runtimeType.toString() == 'RequestOptions') {
        print('android------网络错误');
        if (!checkCode(codeList, Code.NETWORK_TIMEOUT)) {
          Fluttertoast.showToast(
              msg:
                  '操作失败，请重试！网络通信超时', //'${Translations.of(_context).text("message.http10500")}',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: ColorMap.toast_error_color,
              textColor: ColorMap.white,
              gravity: ToastGravity.TOP);
        }
        return new Result(Code.NETWORK_TIMEOUT, '操作失败，请重试！网络通信超时', null);
      }
      // 统一内部处理非零业务编码 passCodeList.length == 0 && 
      if (response.data['status'] != 0) {
        handleResponseStatusCode(response);
      }
      codeList = List();

      // 登录成功重置跳转变量
      if (response.data['status'] == 0 && url == Api.LOGIN) {
        _isLocal = true;
      }

      return new Result(response.data['status'], response.data['msg'],
          response.data['data']); // 返回业务数据
    } catch (e) {
      print('http内部业务代码错误被catch住-------------------$e');
      codeList = List();
      Fluttertoast.showToast(
          msg: '${Translations.of(_context).text("message.http10500")}',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: ColorMap.toast_error_color,
          textColor: ColorMap.white,
          gravity: ToastGravity.TOP);

      return new Result(99999, '程序处理异常', null);
    }
  }

  handleResponseStatusCode(Response response) {
    String nonZeroMsg;
    // 特殊处理状态
    if ((response.data['status'] > 105 &&
            response.data['status'] < 109 &&
            _isLocal) ||
        (response.data['status'] == 101 && _isLocal)) {
      if (ModalRoute.of(_context).settings.name != 'Login') {
        _isLocal = false;
        Navigator.pushNamed(_options.extra['context'], 'Login');
      }
    } else if (response.data['status'] == 912 && _isLocal) {
      // 初始化
      nonZeroMsg = '设备初始化中，请稍后重试';
      if (ModalRoute.of(_context).settings.name != 'Init') {
        _isLocal = false;
        Navigator.pushNamed(_options.extra['context'], 'Init');
      }
    } else if (response.data['status'] == 913) {
      // 设备升级
      nonZeroMsg = '设备正在升级，请稍后重试';
    } else if (response.data['status'] == 914) {
      // 设备自检
      nonZeroMsg = '设备自检中，请稍后重试';
    }
    // && !checkCode(codeList, response.data['status']
    if (null != nonZeroMsg ) {
      Fluttertoast.showToast(
          msg: nonZeroMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);
    }
    if (null == nonZeroMsg &&
        null !=
            Translations.of(_context)
                .text("message.http${response.data["status"]}")) {
                  print('${response.data["status"]}----------${Translations.of(_context).text("message.http${response.data["status"]}")}');
      Fluttertoast.showToast(
          msg:
              '${Translations.of(_context).text("message.http${response.data["status"]}")}',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: ColorMap.toast_error_color,
          textColor: ColorMap.white,
          gravity: ToastGravity.TOP);
    }
  }

  /*
   * @description: 发起网络请求（异步方式）
   * @param { Function } funCallback 回调函数。回调函数的接收参数为Result类型
   * @param { String }  url 请求路径
   * @param { Map }  data 请求数据
   * @param { Options }  options 请求配置信息
   * @param { CancelToken }  可以通过 cancel token 来取消发起的请求
   * @param { List }  passCodeList 外部处理码集合，对其指定的码内部不进行处理
   * @param { bool } whenErrorIsCallback 当发生业务错误时是否调用回调函数，true的时候调用，false不调用，默认值为false
   * return { Result } 改方法不会返回异常，只会返回Result对象
   */
  void requestCallback(Function funCallback, url,
      {data,
      method,
      cancelToken,
      List<int> passCodeList,
      whenErrorIsCallback = false}) async {
    Result result = await request(url,
        data: data,
        method: method,
        cancelToken: cancelToken,
        passCodeList: passCodeList);
    if (result.code != 0) {
      if (whenErrorIsCallback) {
        if (funCallback != null) {
          funCallback(result);
        } else {
          print('回调函数不能为空');
        }
      }
    } else {
      if (funCallback != null) {
        funCallback(result);
      } else {
        print('回调函数不能为空');
      }
    }
  }

  // 网络请求错误处理
  handlerError(DioError e) {
    Response errorResponse;

    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse = new Response(
        statusCode: 888,
        statusMessage: '网络错误'
      ); // 888:网络请求错误处理

      errorResponse.statusCode = httpError(e, _context, false);
    }

    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = Code.NETWORK_TIMEOUT; // 网络超时
      errorResponse.statusMessage = '操作失败，请重试！网络通信超时';
    }


    // Fluttertoast.showToast(msg: '网络请求错误', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP);
    return Result(errorResponse.statusCode, errorResponse.statusMessage, null);
  }

  /*
   * 取消请求
   * 一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消，所以参数可选。
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
