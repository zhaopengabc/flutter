import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/states/edit/InputProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/video/videoplayer.dart';
import 'package:h_pad/states/edit/VideoProvider.dart';

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
  
  bool isPointerDown = false;
  int currentOperatedInputId;
  int currentOperatedCropId;
  VideoPlayer sdk = VideoPlayer.getInstance("cutVideo");

  @override
  Widget build(BuildContext context) {
    InputProvider inputProvider = Provider.of<InputProvider>(context);
    // // print('inputProvider.runtimeType:${inputProvider.runtimeType}');
    
    List<InputModel> inputList = inputProvider.onlineInputList;
    return Container(
        width: Utils.setWidth(867),
        margin: EdgeInsets.only(left: Utils.setWidth(0.5)),
        color: ColorMap.input_background,
        child: ListView.builder(
            // physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: inputList.length,
            itemBuilder: (context, index) {
              return Row(children: <Widget>[
                
                listItem(inputList[index], inputProvider, false, index),
                childList(inputList[index], inputProvider, true),
              ]);
            }));
  }

  Widget childList(InputModel inputModel, InputProvider inputProvider, bool isCrop) {
    final crops = inputModel.crops;
    return crops == null && isCrop
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
                return listItem(inputModel, inputProvider, true, index);
              },
            ),
          );
  }

  Widget listItem(InputModel inputModel, InputProvider inputProvider, bool isCrop, int index){
    final crops = inputModel.crops;
    var inputName = isCrop ? crops[index].name : inputModel.general?.name;
    // int inputIdToView = isCrop ? crops[index].cropId : inputModel.inputId;
    int layerId = isCrop ? (300 + inputModel.inputId * 300 + crops[index].cropId) : inputModel.inputId;
    int type = isCrop ? 1 : 0;
    // print('${inputModel.inputId}--------$layerId-------$type');
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
                            child: inputModel.iSignal == 1? 
                            Consumer<VideoState>(builder: (BuildContext context, data, Widget child) {
                              bool isVideoClosed = data.isVideoClosed == null? false : data.isVideoClosed;
                              return Container(
                                color: ColorMap.layer_bg_nostream,
                                width: Utils.setWidth(204), ////图片的宽
                                height: (!isCrop && inputModel.inputId == inputProvider.currentInputId) 
                                          || (isCrop && inputProvider.getCurrentCropId(inputModel.inputId) != null &&
                                            inputProvider.getCurrentCropId(inputModel.inputId) == crops[index].cropId )
                                      ? Utils.setHeight(104.0)
                                      : Utils.setHeight(106.0), //图片高度
                                // alignment: Alignment.center, //对齐方式
                                child: isVideoClosed? Container(color: ColorMap.layer_noSource_color):
                                // Image.asset(
                                //   'assets/images/input/input1.png',
                                //   fit: BoxFit.fill, //fit缩放模式
                                // ):
                                Consumer<VideoProvider>(builder: (BuildContext context, data, Widget child) {
                                  return sdk.createView(inputModel.inputId, -1, layerId, type, 1==type?crops[index]?.x:0, 1==type?crops[index]?.y:0, 1==type?crops[index]?.width:0, 1==type?crops[index]?.heigth:0, inputModel.resolution?.width, inputModel.resolution?.height, context);
                                }),
                              );
                            })
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
                                  color: (!isCrop && inputModel.inputId == inputProvider.currentInputId) 
                                        || (isCrop && inputProvider.getCurrentCropId(inputModel.inputId) != null &&
                                        inputProvider.getCurrentCropId(inputModel.inputId) == crops[index].cropId )
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
                  // onHorizontalDragStart: (DragStartDetails e){

                  // },
                  // onHorizontalDragUpdate: (DragUpdateDetails e){

                  // },
                  onVerticalDragStart: (DragStartDetails e) {
                    if(isPointerDown) return;
                    currentOperatedInputId = inputModel.inputId;
                    currentOperatedCropId = isCrop? crops[index].cropId : 255;
                    isPointerDown = true;
                    widget.dragDown(e);
                  },
                  onVerticalDragUpdate: (DragUpdateDetails e) {
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
                  onVerticalDragEnd: (DragEndDetails e) {
                    var inputId = inputModel.inputId;
                    var cropId = isCrop? crops[index].cropId : 255;
                    if(inputId!= currentOperatedInputId || (isCrop && cropId!= currentOperatedCropId)) return;
                    widget.dragEnd(e, inputModel, isCrop?crops[index]:null);
                    isPointerDown = false;
                    currentOperatedInputId = -999;
                    currentOperatedCropId = -999;
                  },
                );
  }

}
