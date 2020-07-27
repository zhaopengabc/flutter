<!--
 * @Description: Do not edit
 * @Author: WangZenghe
 * @Date: 2020-02-10 12:06:00
 * @LastEditors: WangZenghe
 * @LastEditTime: 2020-03-18 15:05:01
 -->
# 接口使用示例

```dart
import 'package:flutter/material.dart';
import 'package:h_pad/api/index.dart';

class TestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ScreenView(),
      ),
    );
  }
}

class ScreenView extends StatefulWidget {
  @override
  _ScreenViewState createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView> {
  String resStr = '';

  @override
  void initState() {
    super.initState();

    // 使用方式一 1-1
    Future<List> getScreenList() async {
      HttpUtil http = HttpUtil.getInstance();
      final res = await http.request(Api.SCREEN_LIST, data: {'deviceId':0});
      // final res = await http.request(Api.INPUT_LIST, data：{'deviceId':0});
      // final res = await http.request(Api.LAYER_LIST, data: {'deviceId':0, ''screenId':1});
      final screenList = res.data;
      print(screenList);
      setState(() {
        resStr = screenList.toString();
      });
      return screenList;
    }
    getScreenList();
    // 使用方式一 1-2
    HttpUtil http = HttpUtil.getInstance();
    http.request(Api.SCREEN_LIST, data: {'deviceId':0})
      .then((res) {
        print(res.data.toString());
        setState(() {
          resStr = res.data.toString();
        });
    });

    // 方式二：(支持发生错误时不返回)调用参考代码，第一个参数为回调函数
    void getPresetList(int id) {
      var data = {'deviceId': 0, 'screenId': id};
      HttpUtil http = HttpUtil.getInstance();
      http.requestCallback(funCallBack, Api.Preset_LIST, data: data);
    }

    funCallBack(Result res) {
      print(res);
    }

    // 方式三：(支持发生错误时不返回，且无需实例化)调用参考代码，第一个参数为回调函数
    void getPresetList(int id) {
      var data = {'deviceId': 0, 'screenId': id};
      HttpUtil.requestCallbackStatic(funCallBack, Api.Preset_LIST, data: data);
    }

    funCallBack(Result res) {
      print(res);
    }

    // 方式四：(重写方法一，支持无需实例化)调用参考代码
    void getPresetList(int id) {
      var data = {'deviceId': 0, 'screenId': id};
      Result res = await HttpUtil.requestStatic(Api.Preset_LIST, data: data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(resStr, style: TextStyle(fontSize: 30))
    );
  }
}
```
