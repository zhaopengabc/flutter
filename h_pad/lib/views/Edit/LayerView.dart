// 图层组件
import 'package:flutter/material.dart';


class LayerView  extends StatelessWidget {
  // final x;
  // final y;
  // final w;
  // final h;

  // LayerView({Key key, @required this.x, this.y, this.w, this.h, }): super(key: key);
  final layers;
  LayerView({Key key, @required this.layers }): super(key: key);


  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: <Widget>[
    //     Positioned(
    //       left: x,
    //       top: y,
    //       child: Container(
    //         width: w,
    //         height: h,
    //         decoration: BoxDecoration(
    //           border: Border.all(width:1.0, color: Colors.lightBlueAccent)
    //         ),
    //       ),
    //     )
    //   ],
    // );
    return ListView.separated(
      itemCount: layers.length,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: layers[index]['x'],
              top: layers[index]['y'],
              child: Container(
                width: layers[index]['w'],
                height: layers[index]['h'],
                decoration: BoxDecoration(
                  border: Border.all(width:1.0, color: Colors.lightBlueAccent),
                ),
              ),
            ),
            Text('x ${layers[index]['x']} y: ${layers[index]['y']} w: ${layers[index]['w']} h: ${layers[index]['h']}', style: TextStyle(color:Colors.grey))
          ],
        );
      },
       separatorBuilder: (context, index) {
        return Divider(
          color: Colors.transparent,
        );
      },
    );
  }
}
