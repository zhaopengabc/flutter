import 'package:flutter/material.dart';
import 'package:h_pad/common/CustomerSizeChangedLayoutNotifier.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/states/edit/EditProvider.dart';
import 'package:provider/provider.dart';
import 'package:h_pad/style/colors.dart';

final GlobalKey globalKey = GlobalKey();

class ScreenListView extends StatefulWidget {
  ScreenListView({Key key}) : super(key: key);

  @override
  _ScreenListViewState createState() => _ScreenListViewState();
}

class _ScreenListViewState extends State<ScreenListView>
    with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     print("333----------------");
  //   });
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void didChangeDependencies() {
  //   print('didChangeDependencies');
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(dynamic oldWidget) {
  //   print('didUpdateWidget');
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void deactivate() {
  //   print('deactivate');
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   print('dispose');
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    return NotificationListener<LayoutChangedNotification>(
        onNotification: (notification) {
          /// 收到布局结束通知,打印尺寸
          // _printSize();
          /// flutter1.7之后需要返回值,之前是不需要的.
          _printSize();
          return null;
        },
        child: CustomerSizeChangedLayoutNotifier(
            child: Container(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: editProvider.screenList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: Utils.setWidth(7)),
                        decoration: BoxDecoration(
                        // color: Colors.yellow,
                          border: Border(
                            bottom: BorderSide(
                              width: Utils.setWidth(2.0),
                              color: editProvider.screenList[index]?.screenId ==
                                      editProvider.currentScreenId
                                  ? ColorMap.orange_selected
                                  : Color.fromARGB(00, 00, 00, 00), //边框颜色
                            ),
                          ),
                        ),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: Utils.setWidth(106),//98
                                minWidth: Utils.setWidth(56)),//48
                            child: 
                            // MaterialButton(
                            //   padding: EdgeInsets.all(0.0),
                            //   minWidth: 0.0,
                            GestureDetector(child: 
                            Container(
                              color: Colors.transparent,//Colors.brown[400],
                              height: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: Utils.setWidth(8)),
                              child: Center(
                                widthFactor: 1.0,
                                child:  Text(
                                  "${editProvider.screenList[index].general != null ? editProvider.screenList[index].general.screenName : ""}",
                                  style: TextStyle(
                                    color: editProvider
                                                .screenList[index]?.screenId ==
                                            editProvider.currentScreenId
                                        ? ColorMap.orange_selected
                                        : ColorMap.splitScreen_text_color,
                                    fontSize: Utils.setFontSize(14),
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis),
                                ),
                              // onPressed: () {
                              //   editProvider.currentScreenId =
                              //       editProvider.screenList[index]?.screenId;
                              //   editProvider.selectedLayerId = -1;
                              // },
                            ),
                            onTapDown: (e){
                              if(editProvider.currentScreenId == editProvider.screenList[index]?.screenId) return;
                                editProvider.currentScreenId =
                                    editProvider.screenList[index]?.screenId;
                                editProvider.selectedLayerId = -1;
                                Provider.of<PresetProvider>(context, listen: false).currentPresetId = -1;
                                Provider.of<PresetProvider>(context, listen: false).clear();
                                Provider.of<PresetGroupProvider>(context, listen: false).currentPresetGroupId = -1;
                                Provider.of<PresetGroupProvider>(context, listen: false).clear();
                            },
                          ),
                            
                        ),
                      );
                    }))));
  }

//打印渲染后的组件尺寸
  _printSize() {
    if (!mounted) return;
    var size = context?.findRenderObject()?.paintBounds?.height;
    // print('size=========:${size.toString()}');
  }
}
