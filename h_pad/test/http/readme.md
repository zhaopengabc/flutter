<!--
 * @Description: Do not edit
 * @Author: benmo
 * @Date: 2020-03-04 01:24:51
 * @LastEditors: WangZenghe
 -->


方式1:
  void _loadDericeInfo() {
    HttpClient(context).request(Api.INIT_STATUS, data: {'deviceId': 0}).then((res) {
      print('res.data:${res.data}');
      initStatus = Initstates.fromJson(res.data);
      if (initStatus.initStatus != 1) {
        // 设备无法登录
        Navigator.of(context).pop();
      }
      // todo:  initStatus.languageMode 语言模式
      // initStatus.nomarkMode  中性信息
      _getStatus(initStatus);
      print('initStatus.initStatus:${initStatus.initStatus}');
      // 建立socket 连接
      WebSocketUtil(context).openWebSocket();
    }).catchError((err) {
      print('err: ${err.data}');
    });
  }

方式2:
