import 'dart:math';
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
  ScrollController _scrollController = new ScrollController();//initialScrollOffset: Utils.setWidth(867.0 * 2)
  
  bool isPointerDown = false;
  int currentOperatedInputId;
  int currentOperatedCropId;
  double startX;
  double startY;
  double moveStartX;
  double moveStartY;
  bool isHorizatal = false;
  
  @override
  void initState() {
    // TODO: implement initState
    //  _scrollController.addListener(() {
    //   int offset = _scrollController.position.pixels.toInt();
    //   print("滑动距离$offset");
    //  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputProvider inputProvider = Provider.of<InputProvider>(context);
    // // print('inputProvider.runtimeType:${inputProvider.runtimeType}');
    
    List<InputModel> inputList = inputProvider.onlineInputList;
    return Container(
        width: Utils.setWidth(867),
        margin: EdgeInsets.only(left: Utils.setWidth(0.5)),
        color: ColorMap.input_background,
        child: Listener(
          onPointerDown: (PointerDownEvent e){
            print('listener===========================按下');
            startX = e.localPosition.dx;
            startY = e.localPosition.dy;
            moveStartX = startX;
            moveStartY = startY;
          },
          onPointerMove: (PointerMoveEvent e){
            // print('感应到手势===============================${e.localPosition.dx}--------===${_scrollController.position.pixels}--------------111----------${e.position.dx}');
            if(!isHorizatal) return;
            double x = e.localPosition.dx;
            double y = e.localPosition.dy;
            double distanceY = (y - startY).abs();
            double distanceX = (x - startX).abs();
            var radians = 10 * pi / 180; //10°
            double scale = cos(radians) / sin(radians);
            if(distanceY / distanceX < scale){
              print('listener===========================移动');
              double moveDistanceX = (x - startX).abs();
              isHorizatal = true;
              if(x - startX < 0){
                var dis = _scrollController.position.pixels + moveDistanceX;
                _scrollController.jumpTo(dis > _scrollController.position.maxScrollExtent? _scrollController.position.maxScrollExtent : dis);
              }else{
                var dis = _scrollController.position.pixels - moveDistanceX;
                _scrollController.jumpTo(dis < _scrollController.position.minScrollExtent?  _scrollController.position.minScrollExtent : dis);
              }
            }else{
              isHorizatal = false;
            }
            moveStartY = y;
            moveStartX = x;
          },
          onPointerUp: (PointerUpEvent e){
            print('listener===========================抬起');
            isHorizatal = false;
          },
          child: ListView.builder(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: inputList.length,
            itemBuilder: (context, index) {
              return Row(children: <Widget>[
                listItem(inputList[index], inputProvider, false, index),
                childList(inputList[index], inputProvider, true),
              ]);
            }),
        )
    );
  }

  Widget childList(InputModel inputModel, InputProvider inputProvider, bool isCrop) {
    final crops = inputModel.crops;
    return crops == null && isCrop
        ? null
        : Container(
            // height: Utils.setHeight(100),
            // width: Utils.setWidth(300),
            child: ListView.builder(
              // controller: _scrollController,
              itemCount: crops.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return listItem(inputModel, inputProvider, true, index);
              },
            ),
          );
  }

  Widget listItem(InputModel inputModel, InputProvider inputProvider, bool isCrop, int index){
    final crops = inputModel.crops;
    var inputName = isCrop ? crops[index].name : inputModel.general?.name;
    // if(!isCrop && inputModel.general?.name == 'input 1-1'){
    //   print('输入列表里input1-1的索引$index-------信号${inputModel.iSignal}');
    // }
    // bool hasSignal = false;
    return GestureDetector(
                  key: Key(isCrop ? '${inputModel.inputId}${crops[index].cropId}' : '${inputModel.inputId}00'),
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
                            child: inputModel.iSignal == 1? Image.asset(
                              'assets/images/input/input1.png',
                              width: Utils.setWidth(204), ////图片的宽
                              height: (!isCrop && inputModel.inputId == inputProvider.currentInputId) 
                                      || (isCrop && inputProvider.getCurrentCropId(inputModel.inputId) != null &&
                                        inputProvider.getCurrentCropId(inputModel.inputId) == crops[index].cropId )
                                  ? Utils.setHeight(104.0)
                                  : Utils.setHeight(106.0), //图片高度
                              alignment: Alignment.center, //对齐方式
                              repeat: ImageRepeat.noRepeat, //重复方式
                              fit: BoxFit.fill, //fit缩放模式
                            )
                            : Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              color: ColorMap.layer_noSignal_color,
                              child: Text('${inputModel.iSignal != 1?  "无信号" : ""}',
                                style: TextStyle(color: ColorMap.white),
                                textAlign: TextAlign.center,),),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: (!isCrop && inputModel.inputId == inputProvider.currentInputId) 
                                      || (isCrop && inputProvider.getCurrentCropId(inputModel.inputId) != null &&
                                        inputProvider.getCurrentCropId(inputModel.inputId) == crops[index].cropId )
                                    ? Utils.setWidth(2.0)
                                    : Utils.setWidth(1.0),
                                color: (!isCrop && inputModel.inputId == inputProvider.currentInputId) 
                                      || (isCrop && inputProvider.getCurrentCropId(inputModel.inputId) != null &&
                                        inputProvider.getCurrentCropId(inputModel.inputId) == crops[index].cropId )
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
                              "$inputName",
                              style: TextStyle(
                                  color: inputProvider.getCurrentCropId(
                                                  inputModel.inputId) !=
                                              null &&
                                          inputProvider.getCurrentCropId(
                                                  inputModel.inputId) ==
                                              (isCrop ? crops[index].cropId : inputModel.inputId)
                                      ? Colors.white
                                      : ColorMap.splitScreen_text_color),
                            ),
                          ),
                        ])),
                  ),
                  onPanStart: (DragStartDetails e){
                    print('列表滑动开始');
                    if(isPointerDown) return;
                    currentOperatedInputId = inputModel.inputId;
                    currentOperatedCropId = isCrop? crops[index].cropId : 255;
                    isPointerDown = true;
                    widget.dragDown(e);
                  },
                  onPanUpdate: (DragUpdateDetails e){
                    print('列表滑动更新');
                    if(isHorizatal) return;
                    currentOperatedInputId = inputModel.inputId;
                    currentOperatedCropId = isCrop? crops[index].cropId : 255;
                    isPointerDown = true;


                    var inputId = inputModel.inputId;
                    var cropId = isCrop? crops[index].cropId : 255;
                    if(inputId!= currentOperatedInputId || (isCrop && cropId!= currentOperatedCropId)) return;
                    if(isCrop){
                      inputProvider.setCurrentCrop(
                          inputModel.inputId, crops[index].cropId);
                      inputProvider.currentInputId = -1;
                    }else{
                        inputProvider.currentInputId = inputModel.inputId;
                        inputProvider.setCurrentCrop(-1, -1);
                    }
                    widget.dragUpdate(e);
                  },
                  onPanEnd: (DragEndDetails e){
                    print('列表滑动结束');
                    var inputId = inputModel.inputId;
                    var cropId = isCrop? crops[index].cropId : 255;
                    if(inputId!= currentOperatedInputId || (isCrop && cropId!= currentOperatedCropId)) return;
                    widget.dragEnd(e, inputModel, isCrop?crops[index]:null);
                    isPointerDown = false;
                    currentOperatedInputId = -999;
                    currentOperatedCropId = -999;
                  },

                  // onVerticalDragStart: (DragStartDetails e) {
                  //   if(isPointerDown) return;
                  //   currentOperatedInputId = inputModel.inputId;
                  //   currentOperatedCropId = isCrop? crops[index].cropId : 255;
                  //   isPointerDown = true;
                  //   widget.dragDown(e);
                  // },
                  // onVerticalDragUpdate: (DragUpdateDetails e) {
                  //   var inputId = inputModel.inputId;
                  //   var cropId = isCrop? crops[index].cropId : 255;
                  //   if(inputId!= currentOperatedInputId || (isCrop && cropId!= currentOperatedCropId)) return;
                  //   if(isCrop){
                  //     inputProvider.setCurrentCrop(
                  //         inputModel.inputId, crops[index].cropId);
                  //     inputProvider.currentInputId = -1;
                  //   }else{
                  //       inputProvider.currentInputId = inputModel.inputId;
                  //       inputProvider.setCurrentCrop(-1, -1);
                  //   }
                  //   widget.dragUpdate(e);
                  // },
                  // onVerticalDragEnd: (DragEndDetails e) {
                  //   var inputId = inputModel.inputId;
                  //   var cropId = isCrop? crops[index].cropId : 255;
                  //   if(inputId!= currentOperatedInputId || (isCrop && cropId!= currentOperatedCropId)) return;
                  //   widget.dragEnd(e, inputModel, isCrop?crops[index]:null);
                  //   isPointerDown = false;
                  //   currentOperatedInputId = -999;
                  //   currentOperatedCropId = -999;
                  // },
                );
  }

}
