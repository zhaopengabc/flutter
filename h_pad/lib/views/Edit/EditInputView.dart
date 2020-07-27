// 输入源列表
import 'package:flutter/material.dart';

class EditInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              // color: Colors.lightBlueAccent,
              padding: EdgeInsets.all(5.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  // Text('INPUT-LIST')
                  ListView(
                    scrollDirection: Axis.horizontal,
                    children:<Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input1.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input2.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input3.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input2.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input1.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input3.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input1.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input2.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input1.png'),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(alignment: Alignment.center,
                        children:<Widget>[
                          Image.asset('assets/images/input/input2.png'),
                        ]),
                      ),
                    ]
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
