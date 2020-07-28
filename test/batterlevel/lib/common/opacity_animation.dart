import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrowTransition extends StatelessWidget{
  final Animation<double> animation;
  final Widget child;
  GrowTransition({this.animation, this.child});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: animation,
      builder: (BuildContext context,Widget child){
        return new Center(
          child: new Container(
            width: animation.value,
            height: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}

class AnimationRoute extends StatefulWidget {
  @override
  AnimationRouteState createState() => AnimationRouteState();
}
 
class AnimationRouteState extends State<AnimationRoute> with SingleTickerProviderStateMixin {
 
  Animation<double> animation;
  AnimationController controller;
 
  initState() {
    super.initState();
    // Controller设置动画时长
    // vsync设置一个TickerProvider，当前State 混合了SingleTickerProviderStateMixin就是一个TickerProvider
    controller = AnimationController(
        duration: Duration(seconds: 5),
        vsync: this //
    );
    // Tween设置动画的区间值，animate()方法传入一个Animation，AnimationController继承Animation
    animation = new Tween(begin: 100.0, end: 200.0).animate(controller);
    // controller.repeat();
    controller.repeat(reverse: true);
  }
 
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext ctx, Widget child) {
          return Center(
            child: Container(
              color: Colors.green,
              alignment: Alignment.center,
              width: animation.value,
              height: animation.value,
              child: FloatingActionButton(
                  onPressed: (){
                    controller.stop();
                  },
                  child: Text('停止')
              ),
            ),
          );
        }
    );
  }
 
  @override
  void dispose() {
    // 释放资源
    controller.dispose();
    super.dispose();
  }
}