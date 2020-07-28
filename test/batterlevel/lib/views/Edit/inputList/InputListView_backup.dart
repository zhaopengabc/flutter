import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/style/colors.dart';

class InputListView extends StatefulWidget {
  final Function dragDown;
  final Function dragUpdate;
  final Function dragEnd;
  InputListView({this.dragDown, this.dragUpdate, this.dragEnd});

  @override
  _InputListViewState createState() => _InputListViewState();
}

class _InputListViewState extends State<InputListView> {
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    InputProvider inputProvider = Provider.of<InputProvider>(context);
    // print('inputProvider.runtimeType:${inputProvider.runtimeType}');
    return Container(
        width: Utils.setWidth(867),
        margin: EdgeInsets.only(left: Utils.setWidth(0.5)),
        color: ColorMap.input_background,
        child: ListView.builder(
            // physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: inputProvider.inputList.length,
            itemBuilder: (context, index) {
              return Row(children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    // color: Colors.yellow,
                    margin: EdgeInsets.only(right: Utils.setWidth(16)),
                    padding: EdgeInsets.fromLTRB(Utils.setHeight(10),
                        Utils.setHeight(10), 0, Utils.setHeight(9)),
                    child: SizedBox(
                        width: Utils.setWidth(206),
                        child: Column(children: <Widget>[
                          Container(
                            height: Utils.setHeight(108.0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/input/input1.png',
                              width: Utils.setWidth(204), ////图片的宽
                              height: inputProvider.inputList[index].inputId ==
                                      inputProvider.currentInputId
                                  ? Utils.setHeight(104.0)
                                  : Utils.setHeight(106.0), //图片高度
                              alignment: Alignment.center, //对齐方式
                              repeat: ImageRepeat.noRepeat, //重复方式
                              fit: BoxFit.fill, //fit缩放模式
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: inputProvider.inputList[index].inputId ==
                                        inputProvider.currentInputId
                                    ? Utils.setWidth(2.0)
                                    : Utils.setWidth(1.0),
                                color: inputProvider.inputList[index].inputId ==
                                        inputProvider.currentInputId
                                    ? ColorMap.orange_selected
                                    : ColorMap.input_border_color, //边框颜色
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            height: Utils.setHeight(32),
                            padding: EdgeInsets.symmetric(
                                vertical: Utils.setHeight(4)),
                            // color: Colors.red,
                            alignment: Alignment.center,
                            child: Text(
                                "${inputProvider.inputList[index].general.name}",
                                style: TextStyle(
                                    color: inputProvider
                                                .inputList[index].inputId ==
                                            inputProvider.currentInputId
                                        ? Colors.white
                                        : ColorMap.splitScreen_text_color)),
                          )
                        ])),
                  ),
                  // onTap: () {
                  //   inputProvider.currentInputId =
                  //       inputProvider.inputList[index].inputId;
                  // },
                  // onPanDown: (DragDownDetails e) {
                  //   widget.dragDown(e);
                  // },
                  // // 手指滑动时会触发此回调
                  // onPanUpdate: (DragUpdateDetails e) {
                  //   //用户手指滑动时，更新偏移，重新构建
                  //   setState(() {
                  //     // _left += e.delta.dx;
                  //     // _top += e.delta.dy;
                  //   });
                  //   widget.dragUpdate(e);
                  // },
                  // onPanEnd: (DragEndDetails e) {
                  //   //打印滑动结束时在x、y轴上的速度
                  //   widget.dragEnd(e);
                  // },
                  // 

                  onVerticalDragDown: (DragDownDetails e) {
                    widget.dragDown(e);
                  },
                  onVerticalDragUpdate: (DragUpdateDetails e) {
                    inputProvider.currentInputId =
                        inputProvider.inputList[index].inputId;
                    inputProvider.setCurrentCrop(-1, -1);
                    widget.dragUpdate(e);
                  },
                  onVerticalDragEnd: (DragEndDetails e) {
                    widget.dragEnd(e, inputProvider.inputList[index], null);
                  },
                ),
                childList(inputProvider.inputList[index], inputProvider),
              ]);
            }));
  }

  Widget childList(InputModel inputModel, InputProvider inputProvider) {
    final crops = inputModel.crops;
    return crops == null
        ? null
        : Container(
            // height: Utils.setHeight(100),
            // width: Utils.setWidth(300),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: crops.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: Utils.setWidth(16)),
                    padding: EdgeInsets.fromLTRB(Utils.setHeight(10),
                        Utils.setHeight(10), 0, Utils.setHeight(9)),
                    child: SizedBox(
                        width: Utils.setWidth(206),
                        child: Column(children: <Widget>[
                          Container(
                            height: Utils.setHeight(108.0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/input/input1.png',
                              width: Utils.setWidth(204), ////图片的宽
                              height: inputProvider.getCurrentCropId(
                                              inputModel.inputId) !=
                                          null &&
                                      inputProvider.getCurrentCropId(
                                              inputModel.inputId) ==
                                          crops[index].cropId
                                  ? Utils.setHeight(104.0)
                                  : Utils.setHeight(106.0), //图片高度
                              alignment: Alignment.center, //对齐方式
                              repeat: ImageRepeat.noRepeat, //重复方式
                              fit: BoxFit.fill, //fit缩放模式
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: inputProvider.getCurrentCropId(
                                                inputModel.inputId) !=
                                            null &&
                                        inputProvider.getCurrentCropId(
                                                inputModel.inputId) ==
                                            crops[index].cropId
                                    ? Utils.setWidth(2.0)
                                    : Utils.setWidth(1.0),
                                color: inputProvider.getCurrentCropId(
                                                inputModel.inputId) !=
                                            null &&
                                        inputProvider.getCurrentCropId(
                                                inputModel.inputId) ==
                                            crops[index].cropId
                                    ? ColorMap.orange_selected
                                    : ColorMap.input_border_color, //边框颜色
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            height: Utils.setHeight(32),
                            padding: EdgeInsets.symmetric(
                                vertical: Utils.setHeight(4)),
                            alignment: Alignment.center,
                            child: Text(
                              "${crops[index].name}",
                              style: TextStyle(
                                  color: inputProvider.getCurrentCropId(
                                                  inputModel.inputId) !=
                                              null &&
                                          inputProvider.getCurrentCropId(
                                                  inputModel.inputId) ==
                                              crops[index].cropId
                                      ? Colors.white
                                      : ColorMap.splitScreen_text_color),
                            ),
                          ),
                        ])),
                  ),
                  // onTap: () {
                  //   inputProvider.setCurrentCrop(
                  //       inputModel.inputId, crops[index].cropId);
                  //   inputProvider.currentInputId = -1;
                  // },
                  onVerticalDragDown: (DragDownDetails e) {
                    widget.dragDown(e);
                  },
                  onVerticalDragUpdate: (DragUpdateDetails e) {
                    inputProvider.setCurrentCrop(
                        inputModel.inputId, crops[index].cropId);
                    inputProvider.currentInputId = -1;
                    widget.dragUpdate(e);
                  },
                  onVerticalDragEnd: (DragEndDetails e) {
                    widget.dragEnd(e, inputModel, crops[index]);
                  },
                );
              },
            ),
          );
  }
}
