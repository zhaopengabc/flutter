/*
 * Created by 李卓原 on 2018/9/13.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'package:flutter/material.dart';

class NewsDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetailPage> {
  int text = 1;

  NewsDetailState() {
    print('构造函数');
  }

  @override
  void initState() {
    print('init state');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('widget build');

    return Scaffold(
      body: Center(
        child: _loading(),
      ),
      appBar: AppBar(
        title: Text('咨询详情'),
      ),
    );
  }

  @override
  void didUpdateWidget(NewsDetailPage oldWidget) {
    print('组件状态改变：didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print('移除时：deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('移除时：dispose');
    super.dispose();
  }

  //预加载布局
  Widget _loading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          strokeWidth: 1.0,
        ),
        Container(
          child: Text("正在加载"),
          margin: EdgeInsets.only(top: 10.0),
        )
      ],
    );
  }
}
